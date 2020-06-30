//
//  MockTripService.swift
//  Karhoo
//
//  Created by Vojtech Vrbka on 28/08/2018.
//  Copyright © 2018 Flit Technologies LTD. All rights reserved.
//

import Foundation
import KarhooSDK

@testable import Karhoo

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
    var trackTripIdSet: String?
    func trackTrip(tripId: String) -> PollCall<TripInfo> {
        trackTripIdSet = tripId
        return trackTripCall
    }

    let trackTripStatusCall = MockPollCall<TripState>()
    var trackTripStatusIdSet: String?
    func status(tripId: String) -> PollCall<TripState> {
        trackTripStatusIdSet = tripId
        return trackTripStatusCall
    }
}
