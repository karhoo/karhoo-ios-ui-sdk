//
//  MockFeedbackScreenBuilder.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
@testable import KarhooUISDK

final public class MockTripFeedbackScreenBuilder: TripFeedbackScreenBuilder {

    public var buildFeedbackScreenCalled = false
    public var feedbackScreen = UIViewController()
    public var tripIdSet: String?
    public var callback: ScreenResultCallback<Void>?

    public func buildFeedbackScreen(tripId: String, callback: @escaping ScreenResultCallback<Void>) -> Screen {
        buildFeedbackScreenCalled = true
        self.tripIdSet = tripId
        self.callback = callback
        return feedbackScreen
    }

    public func triggerScreenResult(_ result: ScreenResult<Void>) {
        callback?(result)
    }
}
