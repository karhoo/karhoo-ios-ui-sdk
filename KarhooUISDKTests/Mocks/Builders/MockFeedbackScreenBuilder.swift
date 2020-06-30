//
//  MockFeedbackScreenBuilder.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

@testable import KarhooUISDK

final class MockTripFeedbackScreenBuilder: TripFeedbackScreenBuilder {

    private(set) var buildFeedbackScreenCalled = false
    private(set) var feedbackScreen = UIViewController()
    private(set) var tripIdSet: String?
    private(set) var callback: ScreenResultCallback<Void>?

    func buildFeedbackScreen(tripId: String, callback: @escaping ScreenResultCallback<Void>) -> Screen {
        buildFeedbackScreenCalled = true
        self.tripIdSet = tripId
        self.callback = callback
        return feedbackScreen
    }

    func triggerScreenResult(_ result: ScreenResult<Void>) {
        callback?(result)
    }
}
