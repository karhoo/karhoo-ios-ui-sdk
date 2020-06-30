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

public protocol FeedbackMailComposer: AnyObject {
    func showFeedbackMail() -> Bool
    func reportIssueWith(trip: TripInfo) -> Bool
    func set(parent: UIViewController)
    func showNoCoverageEmail() -> Bool
}

public final class KarhooFeedbackMailComposer: NSObject, FeedbackMailComposer {

    private weak var viewController: UIViewController?

    private let feedbackEmailAddress = "support@karhoo.com"
    private let noCoverageEmailAddress = "suppliers@karhoo.com"
    private let mailComposer = MailComposer()

    public func set(parent: UIViewController) {
        self.viewController = parent
    }

    public func showFeedbackMail() -> Bool {
        guard MFMailComposeViewController.canSendMail() == true && viewController != nil else {
            return false
        }

        _ = mailComposer.presentMailController(from: viewController!,
                                               subject: UITexts.SideMenu.feedback,
                                               recipients: [feedbackEmailAddress],
                                               body: mailMetaInfo())
        return true
    }

    public func reportIssueWith(trip: TripInfo) -> Bool {
        guard MFMailComposeViewController.canSendMail() == true && viewController != nil else {
            return false
        }

        _ = mailComposer.presentMailController(from: viewController!,
                                               subject: "\(UITexts.Generic.reportIssue) Trip: #\(trip.displayId)",
                                               recipients: [feedbackEmailAddress],
                                               body: tripReportBody(trip: trip))
        return true
    }

    public func showNoCoverageEmail() -> Bool {
        guard MFMailComposeViewController.canSendMail() == true && viewController != nil else {
            return false
        }

        _ = mailComposer.presentMailController(from: viewController!,
                                               subject: UITexts.SupportMailMessage.noCoverageEmailSubject,
                                               recipients: [noCoverageEmailAddress],
                                               body: UITexts.SupportMailMessage.noCoverageEmailBody)
        return true
    }

    // MARK: private

    private func mailMetaInfo() -> String {
        let info = """
                   \n \n \n
                   \(UITexts.SupportMailMessage.supportMailMessage)
                   ------------------
                   Device: \(platform())
                   System: \(systemName()) \(systemVersion()))
                   Locale: \(currentLocale())
                   User: \(userInfo())
                   ------------------
                   """
        return info
    }

    private func tripReportBody(trip: TripInfo) -> String {
        let info = """
                   \(UITexts.SupportMailMessage.supportMailReportTrip)
                   \n \n \n
                   ------------------
                   User: \n \(userInfo())
                   Trip: \(trip.displayId)
                   ------------------
                   """
        return info
    }

    private func userInfo() -> String {
        guard let user = Karhoo.getUserService().getCurrentUser() else {
            return ""
        }

        return """
               \(UITexts.User.email): \(user.email)
               \(UITexts.User.mobilePhone): \(user.mobileNumber)
               \(UITexts.User.firstName): \(user.firstName)
               \(UITexts.User.lastName): \(user.lastName)
               """
    }
}

private extension KarhooFeedbackMailComposer {
    func systemName() -> String {
        return UIDevice.current.systemName
    }

    func systemVersion() -> String {
        return UIDevice.current.systemVersion
    }

    func currentLocale() -> String {
        return NSLocale.current.identifier
    }

    func platform() -> String {
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine,
                                  count: Int(_SYS_NAMELEN)),
                      encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
}
