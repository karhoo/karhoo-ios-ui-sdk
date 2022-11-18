//
//  BookingStatusViewModelSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooUISDKTestUtils
@testable import KarhooUISDK

class BookingStatusViewModelSpec: KarhooTestCase {

    private var testObject: BookingStatusViewModel!

    /**
      * Given: A completed trip
      * Then: The view model should be set accordingly
      */
    func testCompletedTrip() {
        let completedTrip = TestUtil.getRandomTrip(state: .completed)
        testObject = BookingStatusViewModel(trip: completedTrip)

        XCTAssert(testObject.imageName == "kh_uisdk_trip_completed")
        XCTAssert(testObject.statusColor == KarhooUI.colors.darkGrey)
    }

    /**kh_uisdk_trip_cancelled")
        XCTAssert(testObject.statusColor == KarhooUI.colors.darkGrey)
    }*/

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
    func testIncompleteTrip() {
        let incompleteTrip = TestUtil.getRandomTrip(state: .incomplete)
        testObject = BookingStatusViewModel(trip: incompleteTrip)
        
        XCTAssertEqual("kh_uisdk_trip_cancelled", testObject.imageName)
        XCTAssertEqual(testObject.statusColor, KarhooUI.colors.darkGrey)
    }
}
