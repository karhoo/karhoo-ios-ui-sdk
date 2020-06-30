//
//  MockBookingAllocationSpinnerView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

@testable import KarhooUISDK

final class MockBookingAllocationSpinnerView: BookingAllocationSpinnerView {

    private(set) var startRotationCalled = false
    func startRotation() {
        startRotationCalled = true
    }

    private(set) var stopRotationCalled = false
    func stopRotation() {
        stopRotationCalled = true
    }
}
