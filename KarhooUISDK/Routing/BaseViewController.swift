//
//  BaseViewController.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
import KarhooSDK
import SwiftUI

public protocol BaseViewController: UIViewController {
    func showAsOverlay(item: Screen, animated: Bool)
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    func push(_ viewController: UIViewController)
    func pop()
    func showAlert(title: String?, message: String, error: KarhooError?)
    func showAlert(title: String?, message: String, error: KarhooError?, actions: [AlertAction])
    func showUpdatePaymentCardAlert(updateCardSelected: @escaping () -> Void, cancelSelected: (() -> Void)?)
    func show(error: KarhooError?)
    func showLoadingOverlay(_ show: Bool)
    func presentUsingBootomSheet<T>(
        title: String,
        bottomSheetContentView: @escaping @autoclosure () -> some View,
        onSheetDismiss: @escaping (ScreenResult<T>) -> Void
    )
}

public extension BaseViewController {
    func showAsOverlay(item: Screen, animated: Bool) {
        let controller = navigationController ?? self
        item.modalPresentationStyle = .overCurrentContext

        if let currentView = controller.presentedViewController {
            if currentView.isBeingDismissed || currentView.isBeingPresented {
                controller.present(item, animated: animated, completion: nil)
                return
            }
            currentView.present(item, animated: animated, completion: nil)
        } else {
            controller.present(item, animated: animated, completion: nil)
        }
    }

    func push(_ viewController: UIViewController) {
        if let navigationItem = self.navigationController {
            navigationItem.pushViewController(viewController, animated: true)
        }
    }

    func pop() {
        if let navigationItem = self.navigationController {
            navigationItem.popViewController(animated: true)
        }
    }

    func showAlert(title: String?, message: String, error: KarhooError?) {
        showAlert(title: title, message: message, error: error, actions: [AlertAction(title: UITexts.Generic.ok, style: .default)])
    }

    func showAlert(title: String?, message: String, error: KarhooError?, actions: [AlertAction]) {
        var messageToShow = message
        if let error = error {
            messageToShow = "\(messageToShow) [\(error.code)]"
        }
        let alert = UIAlertController.create(title: title, message: messageToShow, preferredStyle: .alert)
        actions.forEach { alert.addAction($0.action) }
        alert.view.tintColor = KarhooUI.colors.text

        present(alert, animated: true, completion: nil)
    }

    func show(error: KarhooError?) {
        var message = error?.localizedMessage
        if let msg = message, let error = error, msg.isEmpty == false {
            message = "\(msg) [\(error.code)]"
        } else {
            message = UITexts.Errors.noDetailsAvailable
        }
        let alert = UIAlertController.create(title: UITexts.Errors.somethingWentWrong,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: UITexts.Generic.ok, style: .default))
        alert.view.tintColor = KarhooUI.colors.text

        present(alert, animated: true, completion: nil)
    }

    func showUpdatePaymentCardAlert(updateCardSelected: @escaping () -> Void, cancelSelected: (() -> Void)? = nil) {
        let updateCardAction = UIAlertAction(title: UITexts.PaymentError.paymentAlertUpdateCard,
                                             style: .default,
                                             handler: { _ in
                                                updateCardSelected()
        })

        let cancelAction = UIAlertAction(title: UITexts.Generic.cancel,
                                         style: .cancel,
                                         handler: { _ in
                                            cancelSelected?()
        })

        let alert = UIAlertController.create(title: UITexts.PaymentError.paymentAlertTitle,
                                      message: UITexts.PaymentError.paymentAlertMessage,
                                      preferredStyle: .alert)

        alert.addAction(cancelAction)
        alert.addAction(updateCardAction)
        alert.preferredAction = updateCardAction
        alert.view.tintColor = KarhooUI.colors.text

        present(alert, animated: true, completion: nil)
    }

    func showLoadingOverlay(_ show: Bool) {
        let loadingViewAlpha: CGFloat = 0.5
        let loadingViewTag = 10000

        guard let hostView = (self as UIViewController).view else {
            return
        }

        var loadingView = LoadingView()

        if let currentLoadingView = hostView.viewWithTag(loadingViewTag) as? LoadingView {
            loadingView = currentLoadingView
        } else {
            loadingView.tag = loadingViewTag
            hostView.addSubview(loadingView)
            Constraints.pinEdges(of: loadingView, to: hostView)

            loadingView.alpha = 0
            loadingView.isHidden = true
            loadingView.shouldHideWhenAlphaZero = true
            loadingView.set(backgroundColor: .black, alpha: loadingViewAlpha)
        }

        if show {
            loadingView.show()
        } else {
            loadingView.hide()
        }
    }
    
    func presentUsingBootomSheet<T>(
            title: String,
            bottomSheetContentView: @escaping @autoclosure () -> some View,
            onSheetDismiss: @escaping (ScreenResult<T>) -> Void
    ) {
        let bottomSheetViewModel = KarhooBottomSheetViewModel(
            title: title,
            onDismissCallback: {
                onSheetDismiss(.cancelled(byUser: true))
            }
        )

        let screenBuilder = UISDKScreenRouting.default.bottomSheetScreen()
        let sheet = screenBuilder.buildBottomSheetScreenBuilderForUIKit(viewModel: bottomSheetViewModel) {
            bottomSheetContentView()
        }
        present(sheet, animated: true)
    }
}
