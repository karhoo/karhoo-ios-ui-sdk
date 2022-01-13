//
//  MailComposer.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import MessageUI

protocol MailComposerProtocol {
    func canSendEmail() -> Bool
    func presentMailController(from viewController: UIViewController,
                               subject: String,
                               recipients: [String],
                               body: String) -> MFMailComposeViewController
}

final class MailComposer: NSObject, MFMailComposeViewControllerDelegate, MailComposerProtocol {
    var completion: ((Bool) -> Void)?

    func canSendEmail() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }

    func presentMailController(from viewController: UIViewController,
                               subject: String,
                               recipients: [String],
                               body: String) -> MFMailComposeViewController {
        let mailController = MFMailComposeViewController()
        mailController.mailComposeDelegate = self
        mailController.setSubject(subject)
        mailController.setToRecipients(recipients)
        mailController.setMessageBody(body, isHTML: false)

        viewController.present(mailController, animated: true, completion: nil)

        return mailController
    }

    // MARK: MFMailComposeViewControllerDelegate

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: { [weak self] in
            self?.completion?(result == MFMailComposeResult.sent)
        })
    }
}
