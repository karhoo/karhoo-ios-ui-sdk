//
//  TripInfoUtilitySpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import XCTest
import KarhooSDK

@testable import KarhooUISDK

final class TripInfoUtilitySpec: XCTestCase {

    /**
     * Given: A cancelled trip
     * Then: The utility should return yes when asked if trip is cancelled
     */
    func testCancelledTrip() {
        let cancelledByDispatchTrip = TestUtil.getRandomTrip(state: .driverCancelled)
        let cancelledByUserTrip = TestUtil.getRandomTrip(state: .bookerCancelled)

        XCTAssertTrue(TripInfoUtility.isCancelled(trip: cancelledByDispatchTrip))
        XCTAssertTrue(TripInfoUtility.isCancelled(trip: cancelledByUserTrip))
    }

    /** 
      * Given: A trip that can be cancelled
      * Then: the utility should return yes
      */
    func testIfTripCanBeCancelled() {
        let requestedTrip = TestUtil.getRandomTrip(state: .requested)
        let confirmedTrip = TestUtil.getRandomTrip(state: .confirmed)
        let driverEnRouteTrip = TestUtil.getRandomTrip(state: .driverEnRoute)
        let driverArrivedTrip = TestUtil.getRandomTrip(state: .arrived)

        XCTAssertTrue(TripInfoUtility.canCancel(trip: requestedTrip))
        XCTAssertTrue(TripInfoUtility.canCancel(trip: confirmedTrip))
        XCTAssertTrue(TripInfoUtility.canCancel(trip: driverEnRouteTrip))
        XCTAssertTrue(TripInfoUtility.canCancel(trip: driverArrivedTrip))
    }

    /**
      * Given: A trip where the driver is yet to be allocated
      * Then: the utility should return true
      */
    func testPreDriverAllocation() {
        let requestedTrip = TestUtil.getRandomTrip(state: .requested)
        let confirmedTrip = TestUtil.getRandomTrip(state: .confirmed)

        XCTAssertTrue(TripInfoUtility.preDriverAllocation(trip: requestedTrip))
        XCTAssertTrue(TripInfoUtility.preDriverAllocation(trip: confirmedTrip))
    }

    /**
      * Given: A trip where the driver can be tracked and contacted
      * Then: the utility should return yes
      */
    func testCanTrackAndContactDriver() {
        let driverEnRouteTrip = TestUtil.getRandomTrip(state: .driverEnRoute)
        let driverArrivedTrip = TestUtil.getRandomTrip(state: .arrived)
        let passengerOnBoardTrip = TestUtil.getRandomTrip(state: .passengerOnBoard)

        XCTAssertTrue(TripInfoUtility.canTrackAndContactDriver(trip: driverEnRouteTrip))
        XCTAssertTrue(TripInfoUtility.canTrackAndContactDriver(trip: driverArrivedTrip))
        XCTAssertTrue(TripInfoUtility.canTrackAndContactDriver(trip: passengerOnBoardTrip))
    }

    /**
     *  Given:  DER trip
     *    And:  Driver has no phone number
     *   Then:  CanContactDriver should return false
     */
    func testCanContactDriverNoNumber() {
        let driver = TestUtil.getRandomDriver(phoneNumber: "")
        let vehicle = TestUtil.getRandomVehicle(driver: driver)
        let der = TestUtil.getRandomTrip(state: .driverEnRoute, vehicle: vehicle)
        XCTAssertFalse(TripInfoUtility.canContactDriver(trip: der))
    }

    /**
     *  Given:  DER trip
     *    And:  Driver's phone number is set
     *   Then:  CanContactDriver should return false
     */
    func testCanContactDriver() {
        let der = TestUtil.getRandomTrip(state: .driverEnRoute)
        XCTAssertTrue(TripInfoUtility.canContactDriver(trip: der))
    }

    /**
      * Given a driver with no number
      * TripInfoUtility should return false for canTrackDriver
      */
    func testCanTrackAndContactDriverNoDriverNumber() {
        let driverWithNoNumber = TestUtil.getRandomDriver(phoneNumber: "")
        let vehicle = TestUtil.getRandomVehicle(driver: driverWithNoNumber)
        let tripWithNoDriverNumber = TestUtil.getRandomTrip(vehicle: vehicle)

        XCTAssertFalse(TripInfoUtility.canTrackAndContactDriver(trip: tripWithNoDriverNumber))
    }

    /**
     *  Given:  A driver in states DER, arrived approaching or POB
     *   Then:  CanTrackDriver should return YES
     */
    func testCanTrackDriver() {
        let der = TestUtil.getRandomTrip(state: .driverEnRoute)
        let arrived = TestUtil.getRandomTrip(state: .arrived)
        let pob = TestUtil.getRandomTrip(state: .passengerOnBoard)

        XCTAssertTrue(TripInfoUtility.canTrackDriver(trip: der))
        XCTAssertTrue(TripInfoUtility.canTrackDriver(trip: arrived))
        XCTAssertTrue(TripInfoUtility.canTrackDriver(trip: pob))

        let requested = TestUtil.getRandomTrip(state: .requested)
        let confirmed = TestUtil.getRandomTrip(state: .confirmed)
        let completed = TestUtil.getRandomTrip(state: .completed)
        let cancelledByUser = TestUtil.getRandomTrip(state: .bookerCancelled)
        let cancelledByDispatch = TestUtil.getRandomTrip(state: .driverCancelled)

        XCTAssertFalse(TripInfoUtility.canTrackDriver(trip: requested))
        XCTAssertFalse(TripInfoUtility.canTrackDriver(trip: confirmed))
        XCTAssertFalse(TripInfoUtility.canTrackDriver(trip: completed))
        XCTAssertFalse(TripInfoUtility.canTrackDriver(trip: cancelledByUser))
        XCTAssertFalse(TripInfoUtility.canTrackDriver(trip: cancelledByDispatch))
    }

    /**
      * Given: Some trip state
      * Then: the trip info utility should return its respected generic status as a string
      */
    func testShortTripStateTranslation() {
        XCTAssert(TripInfoUtility.short(tripState: .passengerOnBoard) == UITexts.GenericTripStatus.passengerOnBoard)
    }

    /**
      * When: either origin or destination is an airport
      * Then: info utility should return true
      */
    func testAirportType() {
        let airportPickup = TestUtil.getAirportBookingDetails(originAsAirportAddress: true)
        let airportDestination = TestUtil.getAirportBookingDetails(originAsAirportAddress: false)

        XCTAssert(TripInfoUtility.isAirportBooking(airportPickup))
        XCTAssert(TripInfoUtility.isAirportBooking(airportDestination))
    }

    /**
     * Given: Some trip state
     * Then: the trip info utility should return its respected long status as a string
     */
    func testLongTripStateTranslation() {
        let someTrip = TestUtil.getRandomTrip(state: .passengerOnBoard)

        XCTAssert(TripInfoUtility.longDescription(trip: someTrip) == UITexts.Trip.tripStatusPassengerOnboard)
    }
    
    /**
     * Given: Incomplete trip state
     * Then: the trip info utility should return its respected status as a string
     */
    func testIncompleteTripStatusTranslation() {
        XCTAssert(TripInfoUtility.short(tripState: .incomplete) == UITexts.GenericTripStatus.incomplete)
    }
}
