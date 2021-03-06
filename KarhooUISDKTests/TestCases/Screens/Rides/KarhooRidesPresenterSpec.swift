//
//  KarhooRidesPresenterSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooSDK

@testable import KarhooUISDK

class KarhooRidesPresenterSpec: XCTestCase {

    private var mockRidesView: MockRidesView!
    private var testObject: RidesPresenter!
    private var testCallback: ScreenResult<RidesListAction>?
    private var mockTripsService: MockTripService!

    override func setUp() {
        mockRidesView = MockRidesView()
        mockTripsService = MockTripService()

        testObject = KarhooRidesPresenter(completion: bookingsRootScreenCallback)
        testObject.bind(view: mockRidesView)
    }

    /**
      * When: The view is loaded
      * Then: The title should be set
      */
    func testViewLoad() {
        testObject.bind(view: mockRidesView)
        XCTAssertEqual(mockRidesView.theTitleSet, UITexts.Generic.rides)
    }
    
    /**
     * When: The view is closed
     * Then: The callback should complete and set to cancel
     */
    func testClose() {
        testObject.didPressClose()
        XCTAssert(testCallback?.isCancelledByUser() == true)
    }

    /**
      * When: The user presses track trip
      * Then: routing should be informed via actions
      * And: calllback should complete
      */
    func testTrackTrip() {
        let tripToTrack = TestUtil.getRandomTrip()
        testObject.didPressTrackTrip(trip: tripToTrack)

        if case .trackTrip(let trip) = testCallback!.completedValue()! {
            XCTAssertEqual(trip.tripId, tripToTrack.tripId)
        } else {
            XCTFail("incorrect action result")
        }
    }

    /**
      * When: the user presses the request booking button
      * Then: actions should be called
      * And: callback parameter should complete
      */
    func testRequestTrip() {
        testObject.didPressRequestTrip()

        if case .bookNewTrip = testCallback!.completedValue()! {
            XCTAssertTrue(true)
        } else {
            XCTFail("incorrect action result")
        }
    }

    /**
     * When: the user presses the request booking button
     * Then: actions method should be called
     * And: callback parameter should be called with completed
     */
    func testRebookingTrip() {
        let tripToRebook = TestUtil.getRandomTrip()
        testObject.didPressRebookTrip(trip: tripToRebook)

        if case .rebookTrip(let trip) = testCallback!.completedValue()! {
            XCTAssertEqual(trip.tripId, tripToRebook.tripId)
        } else {
            XCTFail("incorrect action result")
        }
    }

    /**
     * When: the user changes page to upcoming bookings
     * Then: the view should be setting to the correct tab
     */
    func testMovingTabToUpcomingBookings() {
        testObject.bind(view: mockRidesView)
        testObject.didSwitchToPage(index: 0)
        XCTAssertTrue(mockRidesView.movedTabToUpcomingBookings)
        XCTAssertFalse(mockRidesView.movedTabToPastBookings)
    }

    /**
     * When: the user changes page to past bookings
     * Then: the view should be setting to the correct tab
     */
    func testMovingTabToPastBookings() {
        testObject.bind(view: mockRidesView)
        testObject.didSwitchToPage(index: 1)
        XCTAssertTrue(mockRidesView.movedTabToPastBookings)
        XCTAssertFalse(mockRidesView.movedTabToUpcomingBookings)
    }

    private func bookingsRootScreenCallback(result: ScreenResult<RidesListAction>) {
        testCallback = result
    }
}
