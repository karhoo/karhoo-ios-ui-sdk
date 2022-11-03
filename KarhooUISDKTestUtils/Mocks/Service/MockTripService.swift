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

final public class MockTripService: TripService {
    public init() {}

     public let bookCall = MockCall<TripInfo>()
    public var tripBookingSet: TripBooking?
    public func book(tripBooking: TripBooking) -> Call<TripInfo> {
        tripBookingSet = tripBooking
        return bookCall
    }

     public let cancelCall = MockCall<KarhooVoid>()
    public var tripCancellationSet: TripCancellation?
    public func cancel(tripCancellation: TripCancellation) -> Call<KarhooVoid> {
        tripCancellationSet = tripCancellation
        return cancelCall
    }

    public let searchCall = MockCall<[TripInfo]>()
    public var tripSearchSet: TripSearch?
    public func search(tripSearch: TripSearch) -> Call<[TripInfo]> {
        tripSearchSet = tripSearch
        return searchCall
    }

    public let trackTripCall = MockPollCall<TripInfo>()
    public var tripTrackingIdentifierSet: String?
    public func trackTrip(identifier: String) -> PollCall<TripInfo> {
        tripTrackingIdentifierSet = identifier
        return trackTripCall
    }

    public let trackTripStatusCall = MockPollCall<TripState>()
    public var trackTripStatusIdSet: String?
    public func status(tripId: String) -> PollCall<TripState> {
        trackTripStatusIdSet = tripId
        return trackTripStatusCall
    }
    
     public let cancellationFeeCall = MockCall<CancellationFee>()
    public var identifierSet: String?
    public func cancellationFee(identifier: String) -> Call<CancellationFee> {
        identifierSet = identifier
        return cancellationFeeCall
    }
}
