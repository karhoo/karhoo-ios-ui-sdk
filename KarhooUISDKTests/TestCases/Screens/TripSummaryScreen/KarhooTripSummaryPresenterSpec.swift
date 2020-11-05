//
//  KarhooJourneySummaryInfoPresenterSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest

import KarhooSDK
import KarhooUISDK
@testable import KarhooUISDK

class KarhooJourneySummaryPresenterSpec: XCTestCase {

    private var mockAnalytics: MockAnalytics!
    private var mockCallback: ScreenResult<TripSummaryResult>?
    private var mockTrip: TripInfo!
    private var mockJourneySummaryScreen: MockJourneySummaryView!
    private var testObject: KarhooJourneySummaryPresenter!

    override func setUp() {
        mockAnalytics = MockAnalytics()
        mockTrip = TestUtil.getRandomTrip()
        mockJourneySummaryScreen = MockJourneySummaryView()
        testObject = KarhooJourneySummaryPresenter(trip: mockTrip,
                                                   callback: tripSummaryCallback, analytics: mockAnalytics)
    }

    private func tripSummaryCallback(result: ScreenResult<TripSummaryResult>?) {
        mockCallback = result
    }

    /**
      * When: Dismissing summary screen
      * Then: Callback should be called with cancelled by user
      * And:  Analytics event called
      */
    func testDismiss() {
        testObject.exitPressed()

        XCTAssertTrue(mockAnalytics.rideSummaryExitCalled)
        if case .closed = mockCallback!.completedValue()! {
            XCTAssert(true)
        } else {
            XCTFail("Analytics event not called")
        }
    }

    /**
      * When: The screen loads
      * Then: View model should be set
      */
    func testScreenLoading() {
        testObject.viewLoaded(view: mockJourneySummaryScreen)
        XCTAssertNotNil(mockJourneySummaryScreen.tripSet)
    }

    /**
      * When: Book return ride is pressed
      * Then: Reversed booking details should be the callback result
      */
    func testBookingReturnRide() {
        testObject.bookReturnRidePressed()
        XCTAssertTrue(mockAnalytics.returnRideRequestedCalled)

        let returned = mockCallback?.completedValue()
        switch returned {
        case .some(.rebookWithBookingDetails(let booking)):
            XCTAssertEqual(mockTrip.destination?.placeId, booking.originLocationDetails?.placeId)
            XCTAssertEqual(mockTrip.origin.placeId, booking.destinationLocationDetails!.placeId)
        default:
            XCTFail("Reversed booking details not in the callback result")
        }
    }
}
