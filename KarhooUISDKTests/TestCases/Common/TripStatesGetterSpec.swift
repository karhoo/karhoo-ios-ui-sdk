//
//  TripStatesGetterSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
import KarhooSDK

import KarhooUISDKTestUtils
@testable import KarhooUISDK

class TripStatesGetterSpec: KarhooTestCase {

    private var testObject: TripStatesGetter = TripStatesGetter()

    /**
      * When: Requesting for past trips
      * Then: relevant states should be returned
      */
    func testPastStates() {
        let outputStates = testObject.getStatesForTripRequest(type: .past)

        let expectedStates = [TripState.driverCancelled,
                              TripState.bookerCancelled,
                              TripState.completed,
                              TripState.noDriversAvailable,
                              TripState.karhooCancelled,
                              TripState.incomplete]

        XCTAssertEqual(Set(outputStates), Set(expectedStates))
    }

    /**
      * When: Requesting for upcoming trips
      * Then: relevant states should be returned
      */
    func testUpcomingStates() {
        let outputStates = testObject.getStatesForTripRequest(type: .upcoming)

        let expectedStates = [TripState.requested,
                              TripState.confirmed,
                              TripState.driverEnRoute,
                              TripState.arrived,
                              TripState.passengerOnBoard]

        XCTAssertEqual(Set(outputStates), Set(expectedStates))
    }
}
