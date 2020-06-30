//
//  TestMailComposer.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import KarhooSDK
import UIKit

@testable import KarhooUISDK

final class MockFeedbackMailComposer: FeedbackMailComposer {

    var returnValueFeedbackMailCalled = false
    func showFeedbackMail() -> Bool {
        return returnValueFeedbackMailCalled
    }

    var returnValueShowCoverageEmail = false
    func showNoCoverageEmail() -> Bool {
        return returnValueShowCoverageEmail
    }

    var reportedTripCalled: TripInfo?
    var returnValueReportIssueWithTripCalled = false
    func reportIssueWith(trip: TripInfo) -> Bool {
        reportedTripCalled = trip
        return returnValueReportIssueWithTripCalled
    }

    var setViewControllerCalled: UIViewController?
    func set(parent: UIViewController) {
        setViewControllerCalled = parent
    }
}
