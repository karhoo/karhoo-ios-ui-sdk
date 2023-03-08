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
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    private let urlScheme = "com.karhooUISDK.Client.Payments"

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        KarhooUI.set(configuration: KarhooConfig())
        #if canImport(Braintree)
        BTAppContextSwitcher.setReturnURLScheme(urlScheme)
        #endif

        window = UIWindow()
        let mainView = ViewController()
        window?.rootViewController = mainView
        window?.makeKeyAndVisible()
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        if url.scheme?.localizedCaseInsensitiveCompare(urlScheme) == .orderedSame {
            return BTAppContextSwitcher.handleOpenURL(url)
        }
        
        #if canImport(Adyen)
        let adyenThreeDSecureUtils = AdyenThreeDSecureUtils()
        if url.scheme?.localizedCaseInsensitiveCompare(adyenThreeDSecureUtils.current3DSReturnUrlScheme) == .orderedSame {
            return RedirectComponent.applicationDidOpen(from: url)
        }
        #endif
        return false
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            if notification.request.identifier.contains(KarhooAnalitycsServiceWithNotifications.karhooNotificationIdentifierPrefix){
                completionHandler([.alert,.badge])
            }
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void)
    {
        if response.actionIdentifier == UNNotificationDefaultActionIdentifier
            && response.notification.request.identifier.contains(KarhooAnalitycsServiceWithNotifications.karhooNotificationIdentifierPrefix) {
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            if var topController = keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                let alert = UIAlertController(
                    title: response.notification.request.content.title,
                    message: (response.notification.request.content.userInfo["payload_body"] as? String)
                        ?? response.notification.request.content.body,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil)
                )
                topController.present(alert, animated: true, completion: nil)
            }
        }
    }
}
