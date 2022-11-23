//
//  MockTripRatingCache.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

final public class MockTripRatingCache: TripRatingCache {
    public init() {}

    public var saveTripRatingCalled = false
    public func saveTripRated(tripId: String) {
        return saveTripRatingCalled = true
    }

    public var tripRatedValueToReturn: Bool?
    public func tripRated(tripId: String) -> Bool {
        return tripRatedValueToReturn!
    }

    public var clearTripRatingCalled = false
    public func clearTripRatings() {
        clearTripRatingCalled = true
    }

}
