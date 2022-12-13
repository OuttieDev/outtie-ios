![outtiebg1](https://user-images.githubusercontent.com/69208945/207442752-9b73599e-6c50-49e9-b175-cbf48cb4b71d.png)


<h1 align="left"> Outtie iOS SDK</h1>

![Travis](https://img.shields.io/travis/stripe/stripe-ios/master.svg?style=flat)
![CocoaPods](https://img.shields.io/badge/platforms-iOS-orange.svg?maxAge=2592000)
![Languages](https://img.shields.io/badge/languages-Swift-orange.svg?maxAge=2592000)
![License](https://img.shields.io/cocoapods/l/Stripe.svg?style=flat)

The Outtie iOS SDK makes it quick and easy to monetize URL taps in your iOS app. Our SDK helps you add commissionable affiliate links to your iOS apps in minutes. It captures existing URLs and converts them to affiliate links so you can earn every time a user taps a link.

Earn up to 10% commissions from 5,000+ popular brands like Skims, Ulta Beauty, Walmart, Macy's, Nordstrom, Bloomingdale's, Madewell, Alo Yoga, Bonobos, Adidas, and more. Simply integrate Outtie into your app with a few lines of code and start earning on link taps.

Get started by creating a [🔑 Outtie SDK Key](https://outtie.io) and view our [📘 integration examples](#example) below.
<br />
<br />

![outtiebanner](https://user-images.githubusercontent.com/69208945/206001469-e8da6132-8956-450d-8b18-cb3bcbce0c14.png)

Table of contents
=================

<!--ts-->
   * [Features](#features)
   * [Requirements](#requirements)
   * [Installation](#installation)
   * [Usage](#usage)
   * [Example](#example)
   * [Feedback](#feedback)

<!--te-->

## Features

A few of the things you can do with Outtie:

* Automatically create affiliate links and redirect users when they tap a link
* Open links natively within your app or in the Safari app (to enable browser cookies)
* Track unique links for users
* View clicks, sales, and commissions
* Leverage the Outtie Developer API

## Requirements

The Outtie iOS SDK requires Xcode 13.2.1 or later and is compatible with apps targeting iOS 13 or above.


## Installation

Outtie for iOS supports iOS 13+.
Xcode 14 is required to build Outtie iOS SDK.

### Swift Package Manager
Add `https://github.com/OuttieDev/outtie-ios` as a Swift Package Repository in Xcode and follow the instructions to add `Outtie` as a Swift Package.

![outtiespmpic1](https://user-images.githubusercontent.com/69208945/206009405-c4c3c7b3-ca04-4d60-bcba-56e20a5b0185.png)

## Usage

#### Import the SDK in your code:
```swift
import Outtie
``` 

Set your public SDK Key (`pk_live`) and the `clientID` linked to your developer account in `AppDelegate.swift`:

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
     ...
     Outtie.clientID = "2a8c173b-..."
     Outtie.sdkKey = "pk_live_5aT6ia9..."
     ...
     return true
}
```

(Optional) Provide an `externalUID` to track link taps for specific users:

```swift
Outtie.externalUID = "user-418a9..."
```

#### Auto Create & Open Link on Tap
Then, use `openLink` to present a SFSafariViewController (natively within your app) with Outtie when a user taps a link:

```swift
Outtie.openLink(from: self, urlString: "https://www.aloyoga.com/products/m1205r-conquer-reform-crewneck-short-sleeve-dark-heather-grey")
```

Optionally, you can use `openSafariLink` to open the link on the device's Safari app to enable browser cookies and improve tracking:

```swift
Outtie.openSafariLink(from: self, urlString: "https://www.aloyoga.com/products/b1013f-alo-lasting-lip-balm-alo-scent")
```

#### OR, Create a Link to use however you'd like (`createLink` function does not present a view) 
```swift
Outtie.createLink(urlString: "https://www.aloyoga.com") { OuttieLink, OuttieError in
    if let link = OuttieLink {
        //Do whatever you'd like with this link
        print(link)
    }
}
```

## Example

Use `openSafariLink` or `openLink` to open URLs when users tap a link or touch a button:

```swift
import Outtie
```

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    ...
    //(Optional) Provide an `externalUID` to track link taps for specific users:
    Outtie.externalUID = "user-418a9..."
    ...
}
```

```swift
func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
    //Open link in device's Safari app (sets cookie on device Safari which leads to better performance, more tracking)
    Outtie.openSafariLink(from: self, urlString: URL.absoluteString)
    return false
}
```

```swift
func onTouchUpInsideTheLinkButton(url: URL) {
    //Open link inside the app in SFSafariViewController
    Outtie.openLink(from: self, urlString: url.absoluteString)
}
```

## Feedback

Feel free to send us feedback on our [Website](https://outtie.io) or [file an issue](https://github.com/OuttieDev/outtie-ios/issues/new). Feature requests are always welcome.

If there's anything you'd like to chat about, please feel free to email Knox at knox@outtie.io!

