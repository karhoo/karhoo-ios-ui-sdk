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

class MockAlertHandler: AlertHandlerProtocol {
    var displayError: KarhooError?
    func show(error: KarhooError?) -> UIAlertController {
        displayError = error
        return UIAlertController()
    }

    var alertTitle: String?
    var alertMessage: String?
    var alertActions: [AlertAction]?

    func triggerFirstAlertAction() {
        callActionHandler(forButtonIndex: 0)
    }
 
    func triggerSecondAlertAction() {
        callActionHandler(forButtonIndex: 1)
    }

    private func callActionHandler(forButtonIndex buttonIndex: Int) {
        guard let alertAction = alertActions?[buttonIndex] else {
            return
        }
        alertAction.handler?(alertAction.action)
    }

    var firstAlertButtonTitle: String? {
        return alertActions?[0].title
    }

    var secondAlertButtonTitle: String? {
        return alertActions?[1].title
    }

    var alertControllerToReturn: TestAlertController?

    func show(title: String?, message: String?) -> UIAlertController {
        clearData()

        alertTitle = title
        alertMessage = message

        let action = AlertAction(title: UITexts.Generic.ok, style: .default, handler: nil)
        alertActions = [action]
        return alertControllerToReturn ?? TestAlertController()
    }

    func show(title: String?, message: String?, actions: [AlertAction]) -> UIAlertController {
        clearData()

        alertTitle = title
        alertMessage = message
        alertActions = actions

        let alert = alertControllerToReturn ?? TestAlertController()
        alertActions?.forEach { alert.addAction($0.action) }
        return alert
    }

    func clearData() {
        alertTitle = nil
        alertMessage = nil
        alertActions = nil
    }
}

final class TestAlertController: UIAlertController {

    private(set) var dismissCalled = false
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        dismissCalled = true
    }
}
