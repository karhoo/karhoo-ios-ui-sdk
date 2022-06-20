//
//  UIViewController+Extensions.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 04.10.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    func forceLightMode() {
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: KarhooUI.colors.text]
            navigationController?.navigationBar.standardAppearance.largeTitleTextAttributes = [.foregroundColor: KarhooUI.colors.text]
            navigationController?.navigationBar.standardAppearance.backgroundColor = KarhooUI.colors.white
            overrideUserInterfaceStyle = .light
        }
    }
    
    var viewIsOnScreen: Bool{
        return self.isViewLoaded && view.window != nil
    }
}

public extension UIAlertController {
    static func create(title: String?, message: String?, preferredStyle: UIAlertController.Style) -> UIAlertController
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            alert.overrideUserInterfaceStyle = .light
        }
        return alert
    }
}
