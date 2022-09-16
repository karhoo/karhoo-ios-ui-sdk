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
        overrideUserInterfaceStyle = .light
    }
    
    var viewIsOnScreen: Bool{
        self.isViewLoaded && view.window != nil
    }
    
    var viewIsOnScreen: Bool{
        self.isViewLoaded && view.window != nil
    }
}

public extension UIAlertController {
    static func create(
        title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style
    ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.overrideUserInterfaceStyle = .light
        return alert
    }
}
