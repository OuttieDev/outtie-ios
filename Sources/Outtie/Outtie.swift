import Foundation
import UIKit
import SafariServices

@available(iOS 10.0, *)
public class Outtie {
    
    public private(set) var text = "Hello, World!"
    
    private static let baseURL = "https://api.outtie.io"
    
    private static let linkEndpoint = "/create_link"

    /**
         **Required** parameter. Get it from your Outtie.io dashboard, Account Settings, Keys section.
         */
    
    public static var clientID: String!
    
    /**
         **Required** parameter. Get it from your Outtie.io dashboard, Account Settings, Keys section.
         */
    
    public static var sdkKey: String!
    
    /**
         If you provide a value for this parameter, it will be added to the Link created from Outtie.io. Provide this parameter if you would like to track Link taps on a per-user basis.
     
         - Note:
         This parameter is *optional*.
    
         The default value is `nil`.
         - Tag: externalUID
         */
    public static var externalUID: String?
    
    public static func openLink(from viewController: UIViewController, urlString: String) {
        
        guard let url = Outtie.resolveURL(urlString: urlString) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        viewController.present(vc, animated: true)
    }
    
    public static func openSafariLink(from viewController: UIViewController, urlString: String) {
        
        guard let url = Outtie.resolveURL(urlString: urlString) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    public static func createLink(urlString: String, completion: @escaping (URL?, OuttieError?) -> Void) {
        
        guard let url = Outtie.resolveURL(urlString: urlString) else {
            return completion(URL(string: urlString), nil)
        }
        
        // Make request to our createLink endpoint
        let session = URLSession.shared

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "SDK-Key": Outtie.sdkKey!,
            "Client-ID": Outtie.clientID!
        ]
        
        let task = session.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                guard
                    error == nil,
                    let data = data,
                    let responseJson = try? JSONDecoder().decode([String: String].self, from: data)
                else {
                    print(OuttieError.couldNotCreateLink.errorDescription!)
                    return completion(URL(string: urlString), .couldNotCreateLink)
                }
                
                
                guard let OuttieLink = responseJson["outtie_link"] else {
                    print(OuttieError.parsingError.errorDescription!)
                    return completion(URL(string: urlString), .parsingError)
                }
                
                return completion(URL(string: OuttieLink), nil)
            }
            
        }

        task.resume()
        
    }
    
    fileprivate static func resolveURL(urlString: String) -> URL? {
    
        guard let sdkKey = Outtie.sdkKey else {
            print(OuttieError.missingSDKKey.errorDescription!)
            return nil
        }
        
        guard let clientId = Outtie.clientID else {
            print(OuttieError.missingClientID.errorDescription!)
            return nil
        }
        
        var OuttieURL = Outtie.baseURL + Outtie.linkEndpoint + "?sdkKey=\(sdkKey)" + "&clientId=\(clientId)" + "&redirect=\(urlString)"
        
        if let uid = Outtie.externalUID {
            OuttieURL.append(contentsOf: "&externalUID=\(uid)")
        }
        
        guard let url = URL(string: OuttieURL) else {
            print(OuttieError.invalidURL.errorDescription!)
            return nil
        }
        
        return url
    }
    
}


public enum OuttieError: Error {
    
    // Throw when 'clientID' parameter is missing
    case missingClientID
    
    // Throw when 'sdkKey' parameter is missing
    case missingSDKKey
    
    // Throw when the provided URL is invalid
    case invalidURL
    
    // Throw when an no commissionable affiliate link could be created
    case couldNotCreateLink

    // Throw when an expected error parsing response data
    case parsingError

    // Throw in all other cases
    case unexpected(code: Int)
}

// For each error type return the appropriate localized description
extension OuttieError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .missingClientID:
            return NSLocalizedString(
                "Remember to set your 'clientID' parameter before calling any Outtie functions. Find your 'clientId' in your Outtie.io dashboard, Account Settings, Keys section.",
                comment: "Missing 'clientID' parameter"
            )
        case .missingSDKKey:
            return NSLocalizedString(
                "Remember to set your 'sdkKey' parameter before calling any Outtie functions. Find your 'sdkKey' in your Outtie.io dashboard, Account Settings, Keys section.",
                comment: "Missing 'sdkKey' parameter"
            )
        case .invalidURL:
            return NSLocalizedString(
                "The URL you provided is invalid. Please check and make sure this link is still active and reachable.",
                comment: "Invalid URL provided"
            )
        case .couldNotCreateLink:
            return NSLocalizedString(
                "Unable to create an commissionable affiliate link with provided URL.",
                comment: "Error Creating Link"
            )
        case .parsingError:
            return NSLocalizedString(
                "Error returning a Outtie Link",
                comment: "Error Parsing Response Data"
            )
        case .unexpected(_):
            return NSLocalizedString(
                "An unexpected error occurred.",
                comment: "Unexpected Error"
            )
        }
    }
}
