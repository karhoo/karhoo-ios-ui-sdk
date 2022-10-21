//
//  TripMetaDataViewModelSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooSDK
@testable import KarhooUISDK

class TripMetaDataViewModelSpec: KarhooTestCase {

    private var testObject: TripMetaDataViewModel!

    /**
     * When: The view model is initialised with a completed trip
     * Then: The view model properties should be set accordingly
     */
    func testInitialisationWithCompletedTrip() {
        let completedTrip = TestUtil.getRandomTrip(state: .completed)
        testObject = TripMetaDataViewModel(trip: completedTrip)

        XCTAssertEqual(testObject.statusColor, KarhooUI.colors.darkGrey)
        XCTAssertEqual(testObject.statusIconName, "kh_uisdk_trip_completed")
        XCTAssertEqual(testObject.displayId, completedTrip.displayId)
        XCTAssertEqual(testObject.price, completedTrip.farePrice())
    }

    /**
     * When: The view model is initialised with a cancelled trip
     * Then: The view model properties should be set accordingly
     */
    func testInitialisationWithCancelledTrip() {
        let cancelledTrip = TestUtil.getRandomTrip(state: .bookerCancelled)
        testObject = TripMetaDataViewModel(trip: cancelledTrip)

        XCTAssertEqual(testObject.statusColor, KarhooUI.colors.darkGrey)
        XCTAssertEqual(testObject.statusIconName, "kh_uisdk_trip_cancelled")
        XCTAssertEqual(testObject.displayId, cancelledTrip.displayId)
        XCTAssertEqual(testObject.price, cancelledTrip.quotePrice())
    }

    /**
     * When: The view model is initialised with a no drivers available trip
     * Then: The view model properties should be set accordingly
     */
    func testNoDriversAvailableTrip() {
        let noDriversAvailableTrip = TestUtil.getRandomTrip(state: .noDriversAvailable)
        testObject = TripMetaDataViewModel(trip: noDriversAvailableTrip)

        XCTAssertEqual(testObject.statusColor, KarhooUI.colors.darkGrey)
        XCTAssertEqual(testObject.statusIconName, "kh_uisdk_trip_cancelled")
        XCTAssertEqual(testObject.status, UITexts.GenericTripStatus.cancelled)
        XCTAssertEqual(testObject.displayId, noDriversAvailableTrip.displayId)
        XCTAssertEqual(testObject.price, noDriversAvailableTrip.quotePrice())
    }

    /**
     *  Given:  The trip is completed
     *    And:  Fare value is valid
     *   When:  ViewModel initialised
     *   Then:  Price should be set to trip.fare
     */
    func testTripCompletedFare() {
        let fare = TripFare(total: 99999, currency: "GBP", gratuityPercent: 0)
        let completedTrip = TestUtil.getRandomTrip(state: .completed, fare: fare)
        testObject = TripMetaDataViewModel(trip: completedTrip)

        XCTAssertEqual(testObject.price, "£999.99")
    }

    /**
      * When: The trip is upcoming
      * And: Quote is fixed
      * Then: view model should return quote not fare
      * And: Base fare should be hidden
      */
    func testUpcomingRideQuote() {
        let states = TripStatesGetter().getStatesForTripRequest(type: .upcoming)

        states.forEach({ state in
            let quote = TestUtil.getRandomTripQuote(quoteType: .fixed, total: 1000)
            let upcomingTrip = TestUtil.getRandomTrip(state: state, quote: quote)
            testObject = TripMetaDataViewModel(trip: upcomingTrip)
            XCTAssertTrue(testObject.baseFareHidden)
            XCTAssertEqual(testObject.price, "£10.00")
        })
    }

    /**
     * When: The trip is upcoming
     * And: Quote is estimated
     * Then: view model should return quote not fare
     * And: Base fare should not be hidden
     */
    func testUpcomingRideBaseFareQuote() {
        let states = TripStatesGetter().getStatesForTripRequest(type: .upcoming)

        states.forEach({ state in
            let quote = TestUtil.getRandomTripQuote(quoteType: .estimated, total: 1000)
            let upcomingTrip = TestUtil.getRandomTrip(state: state, quote: quote)
            testObject = TripMetaDataViewModel(trip: upcomingTrip)
            XCTAssertFalse(testObject.baseFareHidden)
            XCTAssertEqual(testObject.price, "£10.00")
        })
    }

    /**
     *  Given:  Past trip
     *    And:  Fare value is empty
     *   When:  ViewModel initialised
     *   Then:  Price should be 'Pending'
     */
    func testTripEmptyFare() {
        let tripQuote = TestUtil.getRandomTripQuote()
        let completedTrip = TestUtil.getRandomTrip(state: .completed, fare: TripFare(), quote: tripQuote)
        testObject = TripMetaDataViewModel(trip: completedTrip)

        XCTAssertEqual(testObject.price, UITexts.Bookings.priceCancelled)
    }
    
    func testSetFare() {
        let completedTrip = TestUtil.getRandomTrip(state: .completed)
        testObject = TripMetaDataViewModel(trip: completedTrip)

        let newFare = Fare(breakdown: FareComponent(total: 200.0, currency: "GBP"))
        testObject.setFare(newFare)
        
        XCTAssertEqual(testObject.price, newFare.displayPrice())
    }

    /**
     * When: The SLA has free cancellation minutes
     * Then:  The correct free minutes and display cancellation info is set
     */
    func testFreeCancellationMinutesOnSLA() {
        let sla = ServiceAgreements(serviceCancellation: ServiceCancellation(type: .timeBeforePickup, minutes: 10))
        let cancellableTrip = TestUtil.getRandomTrip(state: .incomplete, serviceAgreements: sla)

        testObject = TripMetaDataViewModel(trip: cancellableTrip)

        XCTAssertEqual(testObject.freeCancellationMessage, "Free cancellation up to 10 minutes before pickup")
    }

    /**
     * When: The SLA has 0 free cancellation minutes
     * Then:  Should not display the free cancellation message
     */
    func testWhenCancellationIsAllowedOnlyWith0MinutesBeforePickupShouldNotDisplayTheCancellationMessage() {
        let sla = ServiceAgreements(serviceCancellation: ServiceCancellation(type: .timeBeforePickup, minutes: 0))
        let uncancellableTrip = TestUtil.getRandomTrip(state: .incomplete, serviceAgreements: sla)

        testObject = TripMetaDataViewModel(trip: uncancellableTrip)

        XCTAssertNil(testObject.freeCancellationMessage)
    }

    /**
     * When: The SLA has free cancellation of type "BeforeDriverEnRoute"
     * Then:  The correct free cancellation message is set
     */
    func testWhenFreeCancellationBeforeDriverOnRouteIsAvailableShouldShowCorrectFreeCancellationMessage() {
        let sla = ServiceAgreements(serviceCancellation: ServiceCancellation(type: .beforeDriverEnRoute))
        let cancellableTrip = TestUtil.getRandomTrip(state: .incomplete, serviceAgreements: sla)

        testObject = TripMetaDataViewModel(trip: cancellableTrip)

        XCTAssertEqual(testObject.freeCancellationMessage, "Free cancellation until the driver is en route")
    }

    /**
     * When: The SLA has no free cancellation minutes
     * Then:  The correct free minutes and display cancellation info is set
     */
    func testNoFreeCancellationMinutesOnSLA() {
        let uncancellableTrip = TestUtil.getRandomTrip(state: .incomplete, serviceAgreements: ServiceAgreements())

        testObject = TripMetaDataViewModel(trip: uncancellableTrip)

        XCTAssertNil(testObject.freeCancellationMessage)
    }
}
