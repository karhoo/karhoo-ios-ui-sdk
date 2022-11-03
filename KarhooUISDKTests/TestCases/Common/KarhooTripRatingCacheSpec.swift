//
//  KarhooTripRatingCacheSpec.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest
@testable import KarhooUISDKTestUtils
@testable import KarhooUISDK

final class KarhooTripRatingCacheSpec: KarhooTestCase {

    private var testObject: KarhooTripRatingCache!
    private var mockUserDefaults = MockUserDefaults()

    override func setUp() {
        super.setUp()

        testObject = KarhooTripRatingCache(userDefaults: mockUserDefaults)
    }

    /**
      * When: Saving a trip rating
      * Then: Defaults should save true for trip rating
      */
    func testSavingRating() {
        testObject.saveTripRated(tripId: "123")
        
        XCTAssertEqual("123", mockUserDefaults.boolKeyValueSet)
        XCTAssertTrue(mockUserDefaults.boolValueSet!)
    }

    /**
     * When: Trip is rated
     * Then: Defaults should return true for trip rating
     */
    func testReadingRatedTrip() {
        mockUserDefaults.boolToReturn = true
        XCTAssertTrue(testObject.tripRated(tripId: "123"))
    }

    /**
     * When: Trip is not rated
     * Then: Defaults should return false for trip rating
     */
    func testReadingTripWithNoRating() {
        mockUserDefaults.boolToReturn = false
        XCTAssertFalse(testObject.tripRated(tripId: "123"))
    }

    /**
     * When: Clearing trip ratings
     * Then: Defaults should be cleared
     * And: synchronize should be called
     */
    func testSynchroniseCalled() {
        testObject.clearTripRatings()

        XCTAssertTrue(mockUserDefaults.synchronizeCalled)
        XCTAssertTrue(mockUserDefaults.removePersistentDomainCalled)
    }
}
