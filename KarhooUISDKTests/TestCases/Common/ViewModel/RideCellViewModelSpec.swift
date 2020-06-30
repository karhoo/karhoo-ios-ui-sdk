//
//  BookingItemViewModelSpec.seift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooSDK

@testable import KarhooUISDK

class BookingItemViewModelSpec: XCTestCase {

    private var testObject: RideCellViewModel!

    /**
      * Given: A cancelled trip
      * Then: The view model should return with a cancelled icon and trip state color as Karhoo primary
      * and: Stack buttons should be set to hidden
      */
    func testCancelledTrip() {
        let userCancelledTrip = TestUtil.getRandomTrip(state: .bookerCancelled)
        testObject = RideCellViewModel(trip: userCancelledTrip)

        cancelledTripAssertions()

        let driverCancelled = TestUtil.getRandomTrip(state: .driverCancelled)
        testObject = RideCellViewModel(trip: driverCancelled)

        cancelledTripAssertions()
    }

    private func cancelledTripAssertions() {
        XCTAssertEqual(testObject.tripStateColor, KarhooUI.colors.darkGrey)
        XCTAssertEqual(testObject.tripStateIconName, "trip_cancelled")
        XCTAssertEqual(testObject.price, testObject.trip.farePrice())
        XCTAssertEqual(testObject.showActionButtons, false)
    }

    /**oh no
      * Given: A completed trip
      * Then: The view model should return with a trip completed icon and trip state color as Karhoo secondary
      * And: The action buttons should not show
      */
    func testCompletedTrip() {
        let completedTrip = TestUtil.getRandomTrip(state: .completed)
        testObject = RideCellViewModel(trip: completedTrip)

        XCTAssertEqual(testObject.tripStateColor, KarhooUI.colors.darkGrey)
        XCTAssertEqual(testObject.tripStateIconName, "trip_completed")
        XCTAssertEqual(testObject.price, completedTrip.farePrice())
        XCTAssertEqual(testObject.showActionButtons, false)
    }

    /**
     * Given: trip with no drivers available
     * Then: The view model should return be set accordingly
     * And: The action buttons should not show
     */
    func testNoDriversAvailable() {
        let noDriversAvailableTrip = TestUtil.getRandomTrip(state: .noDriversAvailable)
        testObject = RideCellViewModel(trip: noDriversAvailableTrip)

        XCTAssertEqual(testObject.tripStateColor, KarhooUI.colors.darkGrey)
        XCTAssertEqual(testObject.tripStateIconName, "trip_cancelled")
        XCTAssertEqual(testObject.tripState, UITexts.GenericTripStatus.cancelled)
        XCTAssertEqual(testObject.showActionButtons, false)
        XCTAssertEqual(testObject.price, UITexts.Bookings.priceCancelled)
    }

    /**
      * Given: A trip that is neither cancelled nor completed nor failed
      * Then: The trip status icon should be nil and the trip state colour should be dark grey
      * And: The action buttons should show
      */
    func testOtherTripState() {
        let inProgressTrip = TestUtil.getRandomTrip(state: .passengerOnBoard)
        testObject = RideCellViewModel(trip: inProgressTrip)

        XCTAssertEqual(testObject.tripStateIconName, "")
        XCTAssertEqual(testObject.tripStateColor, KarhooUI.colors.darkGrey)
        XCTAssertEqual(testObject.showActionButtons, true)
        XCTAssertEqual(testObject.price, inProgressTrip.quotePrice())
    }

    /**
      * Given:  A trip with a fare
      * Then:   the trip should be set with the correct price
      */
    func testPriceSet() {
        let trip = TestUtil.getRandomTrip(fare: TripFare(total: 1111, currency: "GBP", gratuityPercent: 0))
        testObject = RideCellViewModel(trip: trip)

        XCTAssertEqual(testObject.price, "£11.11")
    }
    
    /**
      * Given: An incomplete trip
      * Then: The view model should return with a trip cancelled icon and trip state color as Karhoo secondary
      * And: The action buttons should not show
      */
    func testIncompleteTrip() {
        let incompleteTrip = TestUtil.getRandomTrip(state: .incomplete)
        testObject = RideCellViewModel(trip: incompleteTrip)

        XCTAssertEqual(testObject.tripStateColor, KarhooUI.colors.darkGrey)
        XCTAssertEqual(testObject.tripStateIconName, "trip_cancelled")
        XCTAssertEqual(testObject.price, incompleteTrip.quotePrice())
        XCTAssertFalse(testObject.showActionButtons)
    }

}
