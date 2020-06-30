//
//  MockTripAllocationView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK
@testable import KarhooUISDK

final class MockTripAllocationView: TripAllocationView {

    private(set) var actionsSet: TripAllocationActions?
    func set(actions: TripAllocationActions) {
        actionsSet = actions
    }

    private(set) var tripSet: TripInfo?
    func presentScreen(forTrip trip: TripInfo) {
        tripSet = trip
    }

    private(set) var tripAllocatedCalled: TripInfo?
    func tripAllocated(trip: TripInfo) {
        tripAllocatedCalled = trip
    }

    private(set) var tripCancellationRequestSucceededCalled = false
    func tripCancellationRequestSucceeded() {
        tripCancellationRequestSucceededCalled = true
    }

    private(set) var tripCancellationRequestFailedCalled: KarhooError?
    private(set) var tripCancellationRequestFailedCalledTrip: TripInfo?
    func tripCancellationRequestFailed(error: KarhooError?, trip: TripInfo) {
        tripCancellationRequestFailedCalled = error
        tripCancellationRequestFailedCalledTrip = trip
    }

    private(set) var tripCancelledBySystemCalled = false
    private(set) var tripCancelledBySystemSet: TripInfo?
    func tripCancelledBySystem(trip: TripInfo) {
        tripCancelledBySystemCalled = true
        tripCancelledBySystemSet = trip
    }

    private(set) var resetCancelButtonCalled = false
    func resetCancelButtonProgress() {
        resetCancelButtonCalled = true
    }
}
