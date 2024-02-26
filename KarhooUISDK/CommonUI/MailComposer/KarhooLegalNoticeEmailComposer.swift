//
//  KarhooLegalNoticeEmailComposer.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 01/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK
import MessageUI
import UIKit

public protocol KarhooLegalNoticeMailComposerProtocol: AnyObject {
    func sendLegalNoticeMail(addrees: String) -> Bool
}

public final class KarhooLegalNoticeMailComposer: NSObject, KarhooLegalNoticeMailComposerProtocol {

    private weak var viewController: BaseViewController?
    private let mailComposer = MailComposer()
    private var mailMetaInfoComposer: MailMetaInfoComposer = KarhooMailMetaInfoComposer()

    init(parent: BaseViewController?) {
        self.viewController = parent
    }

    ///   Returns: `true` if is able to open email client
    /// - Parameter addrees: Email addrees of recipient.
    @discardableResult public func sendLegalNoticeMail(addrees: String) -> Bool {
        guard MFMailComposeViewController.canSendMail(), let viewController = viewController else {
            return false
        }
        _ = mailComposer.presentMailController(
            from: viewController,
            subject: UITexts.Booking.legalNotice,
            recipients: [addrees],
            body: mailMetaInfoComposer.getMailMetaInfo()
        )
        return true
    }
}
