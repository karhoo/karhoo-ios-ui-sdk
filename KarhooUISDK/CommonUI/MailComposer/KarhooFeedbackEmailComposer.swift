//
//  MailComposer.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK
import MessageUI

public protocol FeedbackEmailComposer: AnyObject {
    func showFeedbackMail() -> Bool
    func reportIssueWith(trip: TripInfo) -> Bool
    func set(parent: BaseViewController)
    func showNoCoverageEmail() -> Bool
}

public final class KarhooFeedbackEmailComposer: NSObject, FeedbackEmailComposer {

    private weak var viewController: BaseViewController?

    private let mailComposer = MailComposer()
    
    private var mailMetaInfoComposer: MailMetaInfoComposer = KarhooMailMetaInfoComposer()

    public func set(parent: BaseViewController) {
        self.viewController = parent
    }

    public func showFeedbackMail() -> Bool {
        guard MFMailComposeViewController.canSendMail() == true && viewController != nil else {
            return false
        }

        _ = mailComposer.presentMailController(from: viewController!,
                                               subject: UITexts.SupportMailMessage.feedbackEmailSubject,
                                               recipients: [UITexts.SupportMailMessage.feedbackEmailAddress],
                                               body: mailMetaInfoComposer.getMailMetaInfo())
        return true
    }

    public func reportIssueWith(trip: TripInfo) -> Bool {
        guard MFMailComposeViewController.canSendMail() == true && viewController != nil else {
            return false
        }

        _ = mailComposer.presentMailController(from: viewController!,
                                               subject: "\(UITexts.SupportMailMessage.reportIssueEmailSubject): #\(trip.displayId)",
                                               recipients: [UITexts.SupportMailMessage.supportEmailAddress],
                                               body: tripReportBody(trip: trip))
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

    // MARK: private
    private func tripReportBody(trip: TripInfo) -> String {
        let info = """
                   \(UITexts.SupportMailMessage.supportMailReportTrip)
                   ------------------
                   Trip: \(trip.displayId)
                   ------------------
                   \(mailMetaInfoComposer.getMailMetaInfo())
                   """
        return info
    }
}
