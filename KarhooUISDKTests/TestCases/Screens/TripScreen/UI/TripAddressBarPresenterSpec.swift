//
//  TripAddressBarPresenterSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest

@testable import KarhooUISDK

class TripAddressBarPresenterSpec: XCTestCase {

    /**
     *  When:   The screen is loaded
     *  Then:   The spinner should be hidden
     *  And:    The pickup should be set
     *  And:    The destination should be set
     */
    func testScreenLoaded() {
        let testTrip = TestUtil.getRandomTrip()
        let testObject = KarhooTripAddressBarPresenter(trip: testTrip)

        let testAddressBarView = MockAddressBarView()
        testObject.load(view: testAddressBarView)

        XCTAssertTrue(testAddressBarView.setDisplayTripStateCalled)
        XCTAssertEqual(testAddressBarView.pickupDisplayAddressSet, testTrip.origin.displayAddress)
        XCTAssertEqual(testAddressBarView.destinationDisplayAddressSet!, testTrip.destination?.displayAddress)
    }
}
