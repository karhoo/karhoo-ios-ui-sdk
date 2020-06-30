//
//  BookingStatusViewModelSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest

@testable import KarhooUISDK

class BookingStatusViewModelSpec: XCTestCase {

    private var testObject: BookingStatusViewModel!

    /**
      * Given: A completed trip
      * Then: The view model should be set accordingly
      */
    func testCompletedTrip() {
        let completedTrip = TestUtil.getRandomTrip(state: .completed)
        testObject = BookingStatusViewModel(trip: completedTrip)

        XCTAssert(testObject.imageName == "trip_completed")
        XCTAssert(testObject.statusColor == KarhooUI.colors.darkGrey)
    }

    /**
     * Given: A cancelled trip
     * Then: The view model should be set accordingly
     */
    func testCancelledTrip() {
        let cancelledTrip = TestUtil.getRandomTrip(state: .bookerCancelled)
        testObject = BookingStatusViewModel(trip: cancelledTrip)

        XCTAssert(testObject.imageName == "trip_cancelled")
        XCTAssert(testObject.statusColor == KarhooUI.colors.darkGrey)
    }

    /**
     * Given: No drivers available trip state
     * Then: The view model should be set accordingly
     */
    func testNoDriversAvailable() {
        let noDriversAvailableTrip = TestUtil.getRandomTrip(state: .noDriversAvailable)
        testObject = BookingStatusViewModel(trip: noDriversAvailableTrip)

        XCTAssert(testObject.imageName == "trip_cancelled")
        XCTAssert(testObject.statusColor == KarhooUI.colors.darkGrey)
    }

    /**
     * Given: A trip neither completed nor cancelled
     * Then: The view model should be set accordingly
     */
    func testInProgressTrip() {
        let completedTrip = TestUtil.getRandomTrip(state: .passengerOnBoard)
        testObject = BookingStatusViewModel(trip: completedTrip)

        XCTAssert(testObject.imageName == "")
        XCTAssert(testObject.statusColor == KarhooUI.colors.darkGrey)
    }
    
    /**
    * Given: An incomplete trip
    * Then: The view model should be set accordingly
    */
    func testIncompleteTri() {
        let incompleteTrip = TestUtil.getRandomTrip(state: .incomplete)
        testObject = BookingStatusViewModel(trip: incompleteTrip)
        
        XCTAssertEqual("trip_cancelled", testObject.imageName)
        XCTAssertEqual(testObject.statusColor, KarhooUI.colors.darkGrey)
    }
}
