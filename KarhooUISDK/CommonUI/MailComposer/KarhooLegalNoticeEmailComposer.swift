//
//  KarhooLegalNoticeEmailComposer.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 01/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//


import UIKit
import KarhooSDK
import MessageUI

public protocol KarhooLegalNoticeMailComposerProtocol: AnyObject {
    func showLegalNoticekMail() -> Bool
    func set(parent: UIViewController)
}

public final class KarhooLegalNoticeMailComposer: NSObject, KarhooLegalNoticeMailComposerProtocol {

    private weak var viewController: UIViewController?

    private let mailComposer = MailComposer()

    public func set(parent: UIViewController) {
        self.viewController = parent
    }

    public func showLegalNoticekMail() -> Bool {
        guard MFMailComposeViewController.canSendMail() == true && viewController != nil else {
            return false
        }

        // TODO: update email components
        _ = mailComposer.presentMailController(from: viewController!,
                                               subject: "Legal notice mail",
                                               recipients: ["legalNotice@karhoo.com"],
                                               body: "Body")
        return true
    }

    public func showNoCoverageEmail() -> Bool {
        guard MFMailComposeViewController.canSendMail() == true && viewController != nil else {
            return false
        }

        _ = mailComposer.presentMailController(from: viewController!,
                                               subject: UITexts.SupportMailMessage.noCoverageEmailSubject,
                                               recipients: [UITexts.SupportMailMessage.noCoverageEmailAddress],
                                               body: UITexts.SupportMailMessage.noCoverageEmailBody)
        return true
    }


}
