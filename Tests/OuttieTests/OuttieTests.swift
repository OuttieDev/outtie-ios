import XCTest
@testable import Outtie

@available(iOS 10.0, *)
final class OuttieTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Outtie().text, "Hello, World!")
    }
}
