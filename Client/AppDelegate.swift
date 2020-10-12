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
        mainView.view.backgroundColor = .red
        window?.rootViewController = mainView
        window?.makeKeyAndVisible()
        return true
    }
}
