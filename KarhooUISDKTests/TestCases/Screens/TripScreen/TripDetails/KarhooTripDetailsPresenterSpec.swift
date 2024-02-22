//
//  KarhooTripDetailsPresenterSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK
import KarhooUISDKTestUtils
import XCTest
@testable import KarhooUISDK

final class KarhooTripDetailsPresenterSpec: KarhooTestCase {

    private var testObject: KahrooTripScreenDetailsPresenter!
    private var mockTripService: MockTripService!
    private var mockView: MockTripScreenDetailsView!
    private let mockTrip: TripInfo = TestUtil.getRandomTrip()

    override func setUp() {
        super.setUp()

        mockTripService = MockTripService()
        mockView = MockTripScreenDetailsView()
        testObject = KahrooTripScreenDetailsPresenter(tripService: mockTripService,
                                                   view: mockView)
    }

    /**
      * When: Starting
      * Then: Trip service should start observing trip
      */
    func testOnStart() {
        testObject.startMonitoringTrip(tripId: "some")

        XCTAssertTrue(mockTripService.trackTripCall.hasObserver)
    }

    /**
      * When: Getting trip update
      * Then: View should populate with expected view model
      */
    func testTripUpdateOnView() {
        testObject.startMonitoringTrip(tripId: mockTrip.tripId)

        mockTripService.trackTripCall.triggerPollSuccess(mockTrip)

        XCTAssertNotNil(mockView.viewModelSet)
    }

    /**
     * When: Stopping
     * Then: Trip service should not have trip observer
     */
    func testOnStop() {
        testObject.stopMonitoringTrip()

        XCTAssertFalse(mockTripService.trackTripCall.hasObserver)
    }
}
