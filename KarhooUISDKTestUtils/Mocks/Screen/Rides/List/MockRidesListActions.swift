//
//  MockRidesListActions.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

@testable import KarhooUISDK

final public class MockRidesListActions: RidesListActions {
    public init() {}

    public var selectedTrip: TripInfo?
    public func selectedTrip(_ trip: TripInfo) {
        selectedTrip = trip
    }

    public var trackTrip: TripInfo?
    public func trackTrip(_ trip: TripInfo) {
        trackTrip = trip
    }

    public var rebookTrip: TripInfo?
    public func rebookTrip(_ trip: TripInfo) {
        rebookTrip = trip
    }

    public var cancelledTrip: TripInfo?
    public func didCancelTrip(_ trip: TripInfo) {
        cancelledTrip = trip
    }

    public var contactFleetCalled: TripInfo?
    public func contactFleet(_ trip: TripInfo, number: String) {
        contactFleetCalled = trip
    }

    public var contactDriverCalled: TripInfo?
    public func contactDriver(_ trip: TripInfo, number: String) {
        contactDriverCalled = trip
    }
}
