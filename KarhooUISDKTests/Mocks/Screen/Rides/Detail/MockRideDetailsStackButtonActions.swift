//
//  MockRideDetailsStackButtonActions.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

@testable import KarhooUISDK

final class MockRideDetailsStackButtonActions: RideDetailsStackButtonActions {

    private(set) var cancelRideCalled = false
    func cancelRide() {
        cancelRideCalled = true
    }

    private(set) var rebookRideCalled = false
    func rebookRide() {
        rebookRideCalled = true
    }

    private(set) var trackRideCalled = false
    func trackRide() {
        trackRideCalled = true
    }

    private(set) var hideRideOptionsCalled = false
    func hideRideOptions() {
        hideRideOptionsCalled = true
    }

    private(set) var reportIssueErrorCalled = false
    func reportIssueError() {
        reportIssueErrorCalled = true
    }
}
