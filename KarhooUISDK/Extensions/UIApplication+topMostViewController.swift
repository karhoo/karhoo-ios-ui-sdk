//
//  UIApplication+TopMostViewController.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 18/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import UIKit

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        UIApplication.shared.windows.compactMap { window in
            UIApplication.topViewController(of: window)
        }.first
    }

    func topMostBaseViewController() -> BaseViewController? {
        UIApplication.shared.windows.compactMap { window in
            UIApplication.topViewController(of: window) as? BaseViewController
        }.first
    }

    static private func topViewController(of window: UIWindow?) -> UIViewController? {
        guard
            let window,
            var topController = window.rootViewController
        else {
            return nil
        }
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        if let navigationController = topController as? NavigationController {
            topController = navigationController.viewControllers.last ?? navigationController
        }
        return topController
    }
}
