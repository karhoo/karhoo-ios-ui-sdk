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

final public class MockFeedbackMailComposer: FeedbackEmailComposer {

    public var returnValueFeedbackMailCalled = false
    public func showFeedbackMail() -> Bool {
        return returnValueFeedbackMailCalled
    }

    public var returnValueShowCoverageEmail = false
    public func showNoCoverageEmail() -> Bool {
        return returnValueShowCoverageEmail
    }

    public var reportedTripCalled: TripInfo?
    public var returnValueReportIssueWithTripCalled = false
    public func reportIssueWith(trip: TripInfo) -> Bool {
        reportedTripCalled = trip
        return returnValueReportIssueWithTripCalled
    }

    public var setViewControllerCalled: BaseViewController?
    public func set(parent: BaseViewController) {
        setViewControllerCalled = parent
    }
}
