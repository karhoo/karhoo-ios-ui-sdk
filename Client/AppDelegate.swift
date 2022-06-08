//
//  AppDelegate.swift
//  Client
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import KarhooUISDK
import KarhooSDK
#if canImport(Braintree)
import Braintree
#endif
#if canImport(Adyen)
import Adyen
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let urlScheme = "com.karhooUISDK.Client.Payments"

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        KarhooUI.set(configuration: KarhooConfig())
        #if canImport(Braintree)
            BTAppSwitch.setReturnURLScheme(urlScheme)
        #endif

        window = UIWindow()
        let mainView = ViewController()
        window?.rootViewController = mainView
        window?.makeKeyAndVisible()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        if url.scheme?.localizedCaseInsensitiveCompare(urlScheme) == .orderedSame {
            return BTAppSwitch.handleOpen(url, options: options)
        }
        
        #if canImport(Adyen)
        let adyenThreeDSecureUtils = AdyenThreeDSecureUtils()
        if url.scheme?.localizedCaseInsensitiveCompare(adyenThreeDSecureUtils.current3DSReturnUrlScheme) == .orderedSame {
            return RedirectComponent.applicationDidOpen(from: url)
        }
        #endif
        return false
    }
}
