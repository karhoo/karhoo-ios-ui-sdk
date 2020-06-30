//
//  KarhooJourneyDetailsPresenterSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
import KarhooSDK
@testable import KarhooUISDK

final class KarhooJourneyDetailsPresenterSpec: XCTestCase {

    private var testObject: KahrooJourneyDetailsPresenter!
    private var mockTripService: MockTripService!
    private var mockView: MockJourneyDetailsView!
    private let mockTrip: TripInfo = TestUtil.getRandomTrip()

    override func setUp() {
        super.setUp()

        mockTripService = MockTripService()
        mockView = MockJourneyDetailsView()
        testObject = KahrooJourneyDetailsPresenter(tripService: mockTripService,
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
