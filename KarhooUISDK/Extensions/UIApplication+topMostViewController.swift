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
        guard var topController = UIApplication.shared.windows.first?.rootViewController else {
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
