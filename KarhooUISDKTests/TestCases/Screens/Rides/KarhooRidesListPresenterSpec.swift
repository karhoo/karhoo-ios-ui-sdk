//
//  KarhooRidesListPresenterSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooSDK

@testable import KarhooUISDK

final class KarhooRidesListPresenterSpec: XCTestCase {

    private var mockRidesListView: MockRidesListView!
    private var testObject: KarhooRidesListPresenter!
    private var mockRidesListActions: MockRidesListActions!
    private var mockTripsProvider: MockTripsProvider!
    private var mockTripsSorter: MockTripsSorter!
    private var mockRideDetailsScreenBuilder: MockRideDetailsScreenBuilder!

    override func setUp() {
        super.setUp()

        mockRidesListActions = MockRidesListActions()
        mockTripsProvider = MockTripsProvider()
        mockTripsSorter = MockTripsSorter()
        mockRideDetailsScreenBuilder = MockRideDetailsScreenBuilder()

        testObject = KarhooRidesListPresenter(tripsSorter: mockTripsSorter,
                                              tripsProvider: mockTripsProvider,
                                              rideDetailsScreenBuilder: mockRideDetailsScreenBuilder)

        mockRidesListView = MockRidesListView()
        testObject.load(screen: mockRidesListView)
    }

    /**
      * When: fetched an empty list of trips is passed in
      * Then: Then rides list view should set to an empty state
      */
    func testEmptyState() {
        XCTAssert(mockTripsProvider.startCalled)
        mockTripsProvider.delegate?.fetched(trips: [])
        XCTAssert(mockRidesListView.tripsToSet.isEmpty)
        XCTAssert(mockRidesListView.theEmptyStateTitle == UITexts.Bookings.noTrips)
        XCTAssert(mockRidesListView.theEmptyStateMessage == UITexts.Bookings.noTripsBookedMessage)
    }

    /**
      * When: setting trips
      * Then: trips should be set
      */
    func testNonEmptyState() {
        let fetchedTrips = [TestUtil.getRandomTrip()]
        XCTAssert(mockTripsProvider.startCalled)
        mockTripsProvider.delegate?.fetched(trips: fetchedTrips)
        XCTAssert(mockRidesListView.tripsToSet[0].tripId == fetchedTrips[0].tripId)
        XCTAssertFalse(mockRidesListView.emptyStateCalled)
        XCTAssertTrue(mockTripsSorter.sortCalled)
    }

    /**
     * Given: fetching trips fails
     * When: failure is due to some error
     * Then: Empty state message should be set with generic failure text
     */
    func testFetchFailureDueToGenericError() {
        mockTripsProvider.delegate?.tripProviderFailed(error: TestUtil.getRandomError())

        XCTAssertEqual(UITexts.Bookings.noTrips, mockRidesListView.theEmptyStateTitle)
        XCTAssertEqual(UITexts.Bookings.couldNotLoadTrips, mockRidesListView.theEmptyStateMessage)
        XCTAssertFalse(mockTripsSorter.sortCalled)
        XCTAssert(mockRidesListView.tripsToSet.isEmpty)
    }

    /**
      * When: Ride is selected
      * Then: RideDetailsScreenBuilder should be called
      */
    func testRideSelected() {
        let mockTrip = TestUtil.getRandomTrip()
        testObject.rideSelected(mockTrip)

        XCTAssertEqual(mockRideDetailsScreenBuilder.rideDetailsScreenTrip?.tripId, mockTrip.tripId)
        XCTAssertEqual(mockRidesListView.pushViewController, mockRideDetailsScreenBuilder.rideDetailsViewController)
    }
    
    /**
    * When: A new page is selected
    * Then: A new page is requested with offset equal to the current number of current items
    */
    func testNewPageRequest() {
        let randomTrip = [TestUtil.getRandomTrip()]
        testObject.listOfTrips = randomTrip
        testObject.requestNewPage()
        XCTAssertEqual(mockTripsProvider.testPage, randomTrip.count)
    }

    /**
     * When: Rebook Ride is selected on the ride detail screen
     * Then: View should be informed
     * And: Ride details should dismiss
     */
    func rideDetailsRebookTrip() {
        let mockTrip = TestUtil.getRandomTrip()
        testObject.rideSelected(mockTrip)

        mockRideDetailsScreenBuilder.triggerRideDetailsScreenResult(.completed(result: .rebookTrip(mockTrip)))

        XCTAssertEqual(mockTrip.tripId, mockRidesListView.rebookTripSet?.tripId)
        XCTAssertTrue(mockRidesListView.dismissCalled)
    }

    /**
     * When: Track Ride is selected on the ride detail screen
     * Then: View should be informed
     * And: Ride details should dismiss
     */
    func rideDetailsTrackTrip() {
        let mockTrip = TestUtil.getRandomTrip()
        testObject.rideSelected(mockTrip)

        mockRideDetailsScreenBuilder.triggerRideDetailsScreenResult(.completed(result: .trackTrip(mockTrip)))

        XCTAssertEqual(mockTrip.tripId, mockRidesListView.trackTripSet?.tripId)
        XCTAssertTrue(mockRidesListView.dismissCalled)
    }
}
