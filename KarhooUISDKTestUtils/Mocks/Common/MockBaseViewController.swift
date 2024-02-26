//
//  MockBaseViewController.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit
@testable import KarhooUISDK

open class MockBaseViewController: UIViewController, BaseViewController {

    public var showLoadingOverlaySet: Bool?
    public func showLoadingOverlay(_ show: Bool) {
        showLoadingOverlaySet = show
    }

    public var showAsOverlayCalled = false
    public var showAsOverlayScreen: Screen?
    public func showAsOverlay(item: Screen, animated: Bool) {
        showAsOverlayCalled = true
        showAsOverlayScreen = item
    }

    public var dismissCalled = false
    private var dismissCallback: (() -> Void)?
    override public func dismiss(animated: Bool, completion: (() -> Void)?) {
        dismissCalled = true
        dismissCallback = completion
    }

    public func triggerDismissCallback() {
        dismissCallback?()
    }

    public var popCalled = false
    public func pop() {
        popCalled = true
    }

    public var presentViewCalled = false
    public var presentedView: Screen?
    override public func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        presentViewCalled = true
        self.presentedView = viewControllerToPresent
    }

    public var showAlertTitle: String?
    public var showAlertMessage: String?
    public var showAlertCalled = false
    public func showAlert(title: String?, message: String, error: KarhooError?) {
        showAlertTitle = title
        var messageToShow = message
        if let error = error {
            messageToShow = "\(messageToShow) [\(error.code)]"
        }
        showAlertMessage = messageToShow
        showAlertCalled = true
    }

    public var pushViewController: UIViewController?
    public func push(_ viewController: UIViewController) {
        pushViewController = viewController
    }

    public var errorToShow: KarhooError?
    public var showErrorCalled = false
    public func show(error: KarhooError?) {
        errorToShow = error
        showErrorCalled = true
    }

    public var actionAlertTitle: String?
    public var actionAlertMessage: String?
    public var alertActions: [AlertAction] = []
    public func showAlert(title: String?, message: String, error: KarhooError?, actions: [AlertAction]) {
        alertActions.append(contentsOf: actions)
        actionAlertTitle = title
        var messageToShow = message
        if let error = error {
            messageToShow = "\(messageToShow) [\(error.code)]"
        }
        actionAlertMessage = messageToShow
        showAlertCalled = true
    }

    public func triggerAlertAction(atIndex index: Int) {
        let action = alertActions[index]
        action.handler?(action.action)
    }

    public var showPaymentPreAuthAlertCalled = false
    private var updateCardCallback: (() -> Void)?
    private var cancelCallback: (() -> Void)?
    public func showUpdatePaymentCardAlert(updateCardSelected: @escaping () -> Void, cancelSelected: (() -> Void)?) {
        showPaymentPreAuthAlertCalled = true
        self.updateCardCallback = updateCardSelected
        self.cancelCallback = cancelSelected
    }

    public func selectUpdateCardOnAddCardAlert() {
        self.updateCardCallback?()
    }

    public func selectCancelOnUpdateCardAlert() {
        self.cancelCallback?()
    }
}
