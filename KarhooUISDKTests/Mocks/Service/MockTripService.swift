//
//  MockTripService.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

@testable import KarhooUISDK

final class MockTripService: TripService {

    let bookCall = MockCall<TripInfo>()
    var tripBookingSet: TripBooking?
    func book(tripBooking: TripBooking) -> Call<TripInfo> {
        tripBookingSet = tripBooking
        return bookCall
    }

    let cancelCall = MockCall<KarhooVoid>()
    var tripCancellationSet: TripCancellation?
    func cancel(tripCancellation: TripCancellation) -> Call<KarhooVoid> {
        tripCancellationSet = tripCancellation
        return cancelCall
    }

    let searchCall = MockCall<[TripInfo]>()
    var tripSearchSet: TripSearch?
    func search(tripSearch: TripSearch) -> Call<[TripInfo]> {
        tripSearchSet = tripSearch
        return searchCall
    }

    let trackTripCall = MockPollCall<TripInfo>()
    var tripTrackingIdentifierSet: String?
    func trackTrip(identifier: String) -> PollCall<TripInfo> {
        tripTrackingIdentifierSet = identifier
        return trackTripCall
    }

    let trackTripStatusCall = MockPollCall<TripState>()
    var trackTripStatusIdSet: String?
    func status(tripId: String) -> PollCall<TripState> {
        trackTripStatusIdSet = tripId
        return trackTripStatusCall
    }
}
