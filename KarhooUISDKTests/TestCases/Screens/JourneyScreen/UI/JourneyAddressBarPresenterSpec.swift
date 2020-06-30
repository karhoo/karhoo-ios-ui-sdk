//
//  JourneyAddressBarPresenterSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest

@testable import KarhooUISDK

class JourneyAddressBarPresenterSpec: XCTestCase {

    /**
     *  When:   The screen is loaded
     *  Then:   The spinner should be hidden
     *  And:    The pickup should be set
     *  And:    The destination should be set
     */
    func testScreenLoaded() {
        let testTrip = TestUtil.getRandomTrip()
        let testObject = KarhooJourneyAddressBarPresenter(trip: testTrip)

        let testAddressBarView = MockAddressBarView()
        testObject.load(view: testAddressBarView)

        XCTAssertTrue(testAddressBarView.setDisplayJourneyStateCalled)
        XCTAssertEqual(testAddressBarView.pickupDisplayAddressSet, testTrip.origin.displayAddress)
        XCTAssertEqual(testAddressBarView.destinationDisplayAddressSet!, testTrip.destination?.displayAddress)
    }
}
