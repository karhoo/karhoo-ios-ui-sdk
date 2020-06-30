//
//  MockBaseView.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooUISDK
import KarhooSDK

class MockBaseViewController: UIViewController, BaseViewController {

    private(set) var showLoadingOverlaySet: Bool?
    func showLoadingOverlay(_ show: Bool) {
        showLoadingOverlaySet = show
    }

    private(set) var showAsOverlayCalled = false
    private(set) var showAsOverlayScreen: Screen?
    func showAsOverlay(item: Screen, animated: Bool) {
        showAsOverlayCalled = true
        showAsOverlayScreen = item
    }

    private(set) var dismissCalled = false
    private var dismissCallback: (() -> Void)?
    override func dismiss(animated: Bool, completion: (() -> Void)?) {
        dismissCalled = true
        dismissCallback = completion
    }

    func triggerDismissCallback() {
        dismissCallback?()
    }

    private(set) var popCalled = false
    func pop() {
        popCalled = true
    }

    private(set) var presentViewCalled = false
    private(set) var presentedView: Screen?
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        presentViewCalled = true
        self.presentedView = viewControllerToPresent
    }

    private(set) var showAlertTitle: String?
    private(set) var showAlertMessage: String?
    func showAlert(title: String?, message: String) {
        showAlertTitle = title
        showAlertMessage = message
    }

    private(set) var pushViewController: UIViewController?
    func push(_ viewController: UIViewController) {
        pushViewController = viewController
    }

    private(set) var errorToShow: KarhooError?
    func show(error: KarhooError?) {
        errorToShow = error
    }

    private(set) var actionAlertTitle: String?
    private(set) var actionAlertMessage: String?
    private var alertActions: [AlertAction] = []
    func showAlert(title: String?, message: String, actions: [AlertAction]) {
        alertActions.append(contentsOf: actions)
        actionAlertTitle = title
        actionAlertMessage = message
    }

    func triggerAlertAction(atIndex index: Int) {
        let action = alertActions[index]
        action.handler?(action.action)
    }

    private(set) var showPaymentPreAuthAlertCalled = false
    private var updateCardCallback: (() -> Void)?
    private var cancelCallback: (() -> Void)?
    func showUpdatePaymentCardAlert(updateCardSelected: @escaping () -> Void, cancelSelected: (() -> Void)?) {
        showPaymentPreAuthAlertCalled = true
        self.updateCardCallback = updateCardSelected
        self.cancelCallback = cancelSelected
    }

    func selectUpdateCardOnAddCardAlert() {
        self.updateCardCallback?()
    }

    func selectCancelOnUpdateCardAlert() {
        self.cancelCallback?()
    }
}
