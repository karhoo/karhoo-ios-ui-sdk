//
//  EmptyBookingMapStrategySpec.swift
//  KarhooUISDKTests
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import XCTest
@testable import KarhooUISDK

class EmptyBookingMapStrategySpec: XCTestCase {

    private var mockMapView = MockKarhooMapView()
    private var mockUserLocationProvider = MockUserLocationProvider()
    private var testObject = EmptyMapBookingStrategy()
    private let mockBookingStatus = MockBookingStatus()

    override func setUp() {
        super.setUp()

        testObject = EmptyMapBookingStrategy(userLocationProvider: mockUserLocationProvider,
                                             bookingStatus: mockBookingStatus)
        testObject.load(map: mockMapView)

        KarhooTestConfiguration.authenticationMethod = .karhooUser
    }

    /**
     * When: Starting
     * Then: Center pin should hide
     * And: User location provider is set
     * And: Focus button is hidden for guest
     */
    func testStart() {
        testObject.start(bookingDetails: nil)
        XCTAssertFalse(mockMapView.centerPinHidden!)
        XCTAssertNotNil(mockUserLocationProvider.locationChangedCallback)

        let expectedFocusButtonVisibility = KarhooTestConfiguration.authenticationMethod.isGuest()
        XCTAssertEqual(expectedFocusButtonVisibility, mockMapView.focusButtonHiddenSet)
    }

    /**
     * Given: User has location
     * When: focusing map
     * Then: booking status journey info must be updated with new potential origin
     */
    func testFocusMap() {
        mockUserLocationProvider.lastKnownLocation = TestUtil.getRandomLocation()

        testObject.start(bookingDetails: nil)

        XCTAssertNotNil(mockBookingStatus.journeyInfoSet?.origin)
    }

    /**
     * When: focusing map as guest
     * Then: Journey info should be nil (reverse geo not supported)
     */
    func testFocusMapGuest() {
        KarhooTestConfiguration.authenticationMethod = .guest(settings: KarhooTestConfiguration.guestSettings)
        mockUserLocationProvider.lastKnownLocation = TestUtil.getRandomLocation()

        testObject.start(bookingDetails: nil)

        XCTAssertNotNil(mockBookingStatus.journeyInfoSet?.origin)
    }

    /**
     * When: Stopping strategy
     * Then: user location provider should be set to nil
     */
    func testStopStrategy() {
        testObject.stop()
        XCTAssertNil(mockUserLocationProvider.locationChangedCallback)
    }
}
