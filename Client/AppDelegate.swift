//
//  AppDelegate.swift
//  Client
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import KarhooUISDK
import KarhooSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        KarhooUI.set(configuration: KarhooConfig())

        window = UIWindow()
        let mainView = ViewController()
        window?.rootViewController = mainView
        window?.makeKeyAndVisible()
        return true
    }
}

class KarhooConfig: KarhooUISDKConfiguration {

    func environment() -> KarhooEnvironment {
        return .sandbox
    }

    func authenticationMethod() -> AuthenticationMethod {
        return .guest(settings: GuestSettings(identifier: "BQ0AAgUECgwHBQMFBAgHAABAMJCAACCw", referer: "", organisationId: "3c890f69-a92e-4b54-863e-81b880494608"))
    }
}
