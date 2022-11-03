//
//  MockTripRatingCache.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

final class MockTripRatingCache: TripRatingCache {
    
    private(set) var saveTripRatingCalled = false
    func saveTripRated(tripId: String) {
        return saveTripRatingCalled = true
    }

    var tripRatedValueToReturn: Bool?
    func tripRated(tripId: String) -> Bool {
        return tripRatedValueToReturn!
    }

    private(set) var clearTripRatingCalled = false
    func clearTripRatings() {
        clearTripRatingCalled = true
    }

}
