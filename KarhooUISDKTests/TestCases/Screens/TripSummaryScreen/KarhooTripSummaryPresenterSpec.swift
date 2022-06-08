//
//  KarhooTripSummaryInfoPresenterSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
import KarhooSDK
@testable import KarhooUISDK

class KarhooTripSummaryPresenterSpec: KarhooTestCase {

    private var mockAnalytics: MockAnalytics!
    private var mockCallback: ScreenResult<TripSummaryResult>?
    private var mockTrip: TripInfo!
    private var mockTripSummaryScreen: MockTripSummaryView!
    private var testObject: KarhooTripSummaryPresenter!

    override func setUp() {
        super.setUp()
        mockAnalytics = MockAnalytics()
        mockTrip = TestUtil.getRandomTrip()
        mockTripSummaryScreen = MockTripSummaryView()
        testObject = KarhooTripSummaryPresenter(trip: mockTrip,
                                                   callback: tripSummaryCallback, analytics: mockAnalytics)
    }

    private func tripSummaryCallback(result: ScreenResult<TripSummaryResult>?) {
        mockCallback = result
    }

    /**
      * When: The screen loads
      * Then: View model should be set
      */
    func testScreenLoading() {
        testObject.viewLoaded(view: mockTripSummaryScreen)
        XCTAssertNotNil(mockTripSummaryScreen.tripSet)
    }
}
