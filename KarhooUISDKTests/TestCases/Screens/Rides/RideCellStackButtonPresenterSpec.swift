//
//  RideCellStackButtonPresenterSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooUISDKTestUtils
@testable import KarhooUISDK

class RideCellStackButtonPresenterSpec: KarhooTestCase {

    private var testObject: RideCellStackButtonPresenter!
    private var mockStackButtonView: MockStackButtonView!
    private var mockRideCellButtonActions: MockRideCellStackButtonActions!

    override func setUp() {
        super.setUp()

        mockRideCellButtonActions = MockRideCellStackButtonActions()
        mockStackButtonView = MockStackButtonView()
    }

    /**
     * When:   An upcoming trip where the driver is allocated or en route
     * Then:   The presenter should set up two buttons with correct text, contact driver and track driver action
     *  And:   Pressing track driver should invoke a callback
     */
    func testTrackCallDriverOptions() {
        let driverEnROuteTrip = TestUtil.getRandomTrip(state: .driverEnRoute)
        testObject = RideCellStackButtonPresenter(stackButton: mockStackButtonView,
                                                  trip: driverEnROuteTrip,
                                                  rideCellStackButtonActions: mockRideCellButtonActions)

        XCTAssertEqual(mockStackButtonView.firstButtonTextCalled, UITexts.Bookings.contactDriver)
        XCTAssertEqual(mockStackButtonView.secondButtonTextCalled, UITexts.Bookings.trackDriver)

        mockStackButtonView.secondButtonAction?()

        XCTAssertTrue(mockRideCellButtonActions.trackTripCalled)
    }

    /**
     * Given: An upcoming trip where the driver is not yet en route or allocated
     * Then: The presenter should set up one button with correct text and contact supplier option
     */
    func testPreTripTrip() {
        let preDriverAllocatedTrip = TestUtil.getRandomTrip(state: .confirmed)
        testObject = RideCellStackButtonPresenter(stackButton: mockStackButtonView,
                                                  trip: preDriverAllocatedTrip,
                                                  rideCellStackButtonActions: mockRideCellButtonActions)

        XCTAssertEqual(mockStackButtonView.singleButtonTextCalled, UITexts.Bookings.contactFleet)
    }

    /**
     * Given:   The trip is in progress (passenger on board)
     *  Then:   The presenter should set up one button with correct text (track trip)
     */
    func testPassengerOnBoardTrip() {
        let passengerOnBoardTrip = TestUtil.getRandomTrip(state: .passengerOnBoard)
        testObject = RideCellStackButtonPresenter(stackButton: mockStackButtonView,
                                                  trip: passengerOnBoardTrip,
                                                  rideCellStackButtonActions: mockRideCellButtonActions)

        XCTAssertEqual(mockStackButtonView.singleButtonTextCalled, UITexts.Bookings.trackTrip)

        mockStackButtonView.singleButtonAction?()
        XCTAssertTrue(mockRideCellButtonActions.trackTripCalled)
    }

    /**
     * Given:   Trip state is DER
     *   And:   Driver contact numer is not provided
     *  Then:   'Track driver' button should be displayed
     */
    func testDerNoContactDriver() {
        let driver = TestUtil.getRandomDriver(phoneNumber: "")
        let vehicle = TestUtil.getRandomVehicle(driver: driver)
        let trip = TestUtil.getRandomTrip(state: .driverEnRoute, vehicle: vehicle)

        testObject = RideCellStackButtonPresenter(stackButton: mockStackButtonView,
                                                  trip: trip,
                                                  rideCellStackButtonActions: mockRideCellButtonActions)

        XCTAssertEqual(mockStackButtonView.singleButtonTextCalled, UITexts.Bookings.trackTrip)

        mockStackButtonView.singleButtonAction?()
        XCTAssertTrue(mockRideCellButtonActions.trackTripCalled)
    }
}
