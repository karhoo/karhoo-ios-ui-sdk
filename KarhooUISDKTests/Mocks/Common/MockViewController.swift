//
//  MockViewController.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import UIKit

class MockViewController: UIViewController {

    var dismissCallback: (() -> Void)?
    var dismissCalled = false
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissCalled = true
        dismissCallback = completion
    }

    override var presentedViewController: UIViewController? {
        return presentedItem
    }
    
    var presentedItem: UIViewController?
    var presentAnimated: Bool?
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        presentedItem = viewControllerToPresent
        presentAnimated = flag
    }
}
