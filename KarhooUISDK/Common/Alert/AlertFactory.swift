//
//  AlertFactory.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

public final class AlertFactory {

    public static func showForceUpdateAlert(withHandler alertHandler: AlertHandlerProtocol,
                                            updateAction: @escaping () -> Void) -> UIAlertController {
        let updateAlertAction = AlertAction(title: UITexts.Errors.forceUpdateButton,
                                            style: .default) { _ in
                                                updateAction()
        }
        return alertHandler.show(title: UITexts.Errors.forceUpdateTitle,
                                 message: UITexts.Errors.forceUpdateMessage,
                                 actions: [updateAlertAction])
    }
    
    public static func showSignupFinishedAlert(withHandler alertHandler: AlertHandlerProtocol) -> UIAlertController {
        return alertHandler.show(title: UITexts.Generic.thanks, message: UITexts.User.signupPendingMessage)
    }

    public static func showCantSendEmail(withHandler alertHandler: AlertHandlerProtocol) {
        alertHandler.show(message: UITexts.Errors.cantSendEmail)
    }

    private static func cancelAction() -> AlertAction {
        return AlertAction(title: UITexts.Generic.cancel, style: .default, handler: nil)
    }
}
