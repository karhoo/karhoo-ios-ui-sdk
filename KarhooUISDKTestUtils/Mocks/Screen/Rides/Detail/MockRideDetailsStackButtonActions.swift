//
//  MockRideDetailsStackButtonActions.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

@testable import KarhooUISDK

final public class MockRideDetailsStackButtonActions: RideDetailsStackButtonActions {

    public var cancelRideCalled = false
    public func cancelRide() {
        cancelRideCalled = true
    }

    public var rebookRideCalled = false
    public func rebookRide() {
        rebookRideCalled = true
    }

    public var trackRideCalled = false
    public func trackRide() {
        trackRideCalled = true
    }

    public var hideRideOptionsCalled = false
    public func hideRideOptions() {
        hideRideOptionsCalled = true
    }

    public var reportIssueErrorCalled = false
    public func reportIssueError() {
        reportIssueErrorCalled = true
    }

    public var contactFleetCalled = false
    public func contactFleet(_ phoneNumber: String) {
        contactFleetCalled = true
    }

    public var contactDriverCalled = false
    public func contactDriver(_ phoneNumber: String) {
        contactDriverCalled = true
    }
}
