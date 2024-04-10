//
//  MockTripAllocationView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK
@testable import KarhooUISDK

final public class MockTripAllocationView: UIView, TripAllocationView {
    
    public init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public var tripDriverAllocationDelayedCalled = false

    public var actionsSet: TripAllocationActions?
    public func set(actions: TripAllocationActions) {
        actionsSet = actions
    }

    public var tripSet: TripInfo?
    public func presentScreen(forTrip trip: TripInfo) {
        tripSet = trip
    }

    public var tripAllocatedCalled: TripInfo?
    public func tripAllocated(trip: TripInfo) {
        tripAllocatedCalled = trip
    }

    public var tripCancellationRequestSucceededCalled = false
    public func tripCancellationRequestSucceeded() {
        tripCancellationRequestSucceededCalled = true
    }

    public var tripCancellationRequestFailedCalled: KarhooError?
    public var tripCancellationRequestFailedCalledTrip: TripInfo?
    public func tripCancellationRequestFailed(error: KarhooError?, trip: TripInfo) {
        tripCancellationRequestFailedCalled = error
        tripCancellationRequestFailedCalledTrip = trip
    }

    public var tripCancelledBySystemCalled = false
    public var tripCancelledBySystemSet: TripInfo?
    public func tripCancelledBySystem(trip: TripInfo) {
        tripCancelledBySystemCalled = true
        tripCancelledBySystemSet = trip
    }

    public var resetCancelButtonCalled = false
    public func resetCancelButtonProgress() {
        resetCancelButtonCalled = true
    }
    
    public func tripDriverAllocationDelayed(trip: TripInfo) {
        tripDriverAllocationDelayedCalled = true
    }
    
    public var screenDismissed = false
    public func dismissScreen() {
        screenDismissed = true
    }
}
