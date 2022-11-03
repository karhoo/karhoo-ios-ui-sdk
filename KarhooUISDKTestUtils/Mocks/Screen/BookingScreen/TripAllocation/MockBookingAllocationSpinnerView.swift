//
//  MockBookingAllocationSpinnerView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

@testable import KarhooUISDK

final public class MockBookingAllocationSpinnerView: BookingAllocationSpinnerView {
    public init() {}

    public var startRotationCalled = false
    public func startRotation() {
        startRotationCalled = true
    }

    public var stopRotationCalled = false
    public func stopRotation() {
        stopRotationCalled = true
    }
}
