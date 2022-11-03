//
//  MockViewController.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import UIKit

public class MockViewController: UIViewController {

    public var dismissCallback: (() -> Void)?
    public var dismissCalled = false
    override public func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissCalled = true
        dismissCallback = completion
    }

    override public var presentedViewController: UIViewController? {
        return presentedItem
    }
    
    public var presentedItem: UIViewController?
    public var presentAnimated: Bool?
    override public func present(_ viewControllerToPresent: UIViewController, animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        presentedItem = viewControllerToPresent
        presentAnimated = flag
    }

    override public func loadView() {
        view = UIView()
        navigationItem.title = ""
        navigationItem.backButtonTitle = ""
    }
}
