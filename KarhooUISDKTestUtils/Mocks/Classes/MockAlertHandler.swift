//
//  MockAlertHandler.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import UIKit
import KarhooSDK

@testable import KarhooUISDK

public class MockAlertHandler: AlertHandlerProtocol {
    public init() {}

    public var displayError: KarhooError?
    public func show(error: KarhooError?) -> UIAlertController {
        displayError = error
        return UIAlertController()
    }

    public var alertTitle: String?
    public var alertMessage: String?
    public var alertActions: [AlertAction]?

    public func triggerFirstAlertAction() {
        callActionHandler(forButtonIndex: 0)
    }
 
    public func triggerSecondAlertAction() {
        callActionHandler(forButtonIndex: 1)
    }

    private func callActionHandler(forButtonIndex buttonIndex: Int) {
        guard let alertAction = alertActions?[buttonIndex] else {
            return
        }
        alertAction.handler?(alertAction.action)
    }

    public var firstAlertButtonTitle: String? {
        return alertActions?[0].title
    }

    public var secondAlertButtonTitle: String? {
        return alertActions?[1].title
    }

    public var alertControllerToReturn: TestAlertController?

    public func show(title: String?, message: String?) -> UIAlertController {
        clearData()

        alertTitle = title
        alertMessage = message

        let action = AlertAction(title: UITexts.Generic.ok, style: .default, handler: nil)
        alertActions = [action]
        return alertControllerToReturn ?? TestAlertController()
    }

    public func show(title: String?, message: String?, actions: [AlertAction]) -> UIAlertController {
        clearData()

        alertTitle = title
        alertMessage = message
        alertActions = actions

        let alert = alertControllerToReturn ?? TestAlertController()
        alertActions?.forEach { alert.addAction($0.action) }
        return alert
    }

    public func clearData() {
        alertTitle = nil
        alertMessage = nil
        alertActions = nil
    }
}

final public class TestAlertController: UIAlertController {

    public var dismissCalled = false
    override public func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        dismissCalled = true
    }
}
