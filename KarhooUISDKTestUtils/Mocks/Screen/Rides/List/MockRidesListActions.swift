//
//  MockRidesListActions.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

@testable import KarhooUISDK

final class MockRidesListActions: RidesListActions {

    private(set) var selectedTrip: TripInfo?
    func selectedTrip(_ trip: TripInfo) {
        selectedTrip = trip
    }

    private(set) var trackTrip: TripInfo?
    func trackTrip(_ trip: TripInfo) {
        trackTrip = trip
    }

    private(set) var rebookTrip: TripInfo?
    func rebookTrip(_ trip: TripInfo) {
        rebookTrip = trip
    }

    private(set) var cancelledTrip: TripInfo?
    func didCancelTrip(_ trip: TripInfo) {
        cancelledTrip = trip
    }

    private(set) var contactFleetCalled: TripInfo?
    func contactFleet(_ trip: TripInfo, number: String) {
        contactFleetCalled = trip
    }

    private(set) var contactDriverCalled: TripInfo?
    func contactDriver(_ trip: TripInfo, number: String) {
        contactDriverCalled = trip
    }
}
