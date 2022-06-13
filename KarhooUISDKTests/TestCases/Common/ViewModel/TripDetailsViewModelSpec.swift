//
//  TripDetailsViewModelSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooSDK

@testable import KarhooUISDK

class TripDetailsViewModelSpec: KarhooTestCase {

    private var testObject: TripDetailsViewModel!

    /**
      * When: The view model is initialised with an asap trip
      * Then: The view model properties should be set accordingly
      */
    func testViewModelInitialisation() {
        let testTrip = TestUtil.getRandomTrip(dateSet: false, state: .driverEnRoute)
        testObject = TripDetailsViewModel(trip: testTrip)

        let dateFormatter = KarhooDateFormatter(timeZone: testTrip.destination?.timezone() ?? TimeZone.current)
        XCTAssertEqual(testObject.pickup, testTrip.origin.displayAddress)
        XCTAssertEqual(testObject.vehicleInformation,
                       "\(testTrip.vehicle.description) \(testTrip.vehicle.vehicleLicensePlate)")
        XCTAssertEqual(testObject.supplierName, testTrip.fleetInfo.name)
        XCTAssertEqual(testObject.supplierLogoStringURL, testTrip.fleetInfo.logoUrl)
        XCTAssertEqual(testObject.formattedDate, dateFormatter.display(detailStyleDate: testTrip.dateScheduled))
    }

    /**
      * When: The trip view model is initialised
      * And: The driver is en route or arrived or POB or completed
      * Then: The vehicle model and registration should be shown
      */
    func testViewModelShowsVehicleRegistration() {
        [TripState.driverEnRoute, TripState.arrived, TripState.passengerOnBoard, TripState.completed].forEach { state in
            let trip = TestUtil.getRandomTrip(dateSet: true, state: state)
            testObject = TripDetailsViewModel(trip: trip)
            XCTAssertEqual(testObject.vehicleInformation,
                           "\(trip.vehicle.description) \(trip.vehicle.vehicleLicensePlate)")
        }
    }

    /**
     * When: The trip view model is initialised
     * And: The driver is neither en route nor arrived nor POB nor completed
     * Then: The vehicle description should be shown
     */
    func testViewModelShowsVehicleDescription() {
        [TripState.requested,
         TripState.noDriversAvailable,
         TripState.confirmed,
         TripState.bookerCancelled,
         TripState.driverCancelled,
         TripState.unknown].forEach { state in
            let trip = TestUtil.getRandomTrip(dateSet: true, state: state)
            testObject = TripDetailsViewModel(trip: trip)
            XCTAssertTrue(testObject.vehicleInformation == "\(trip.vehicle.description)")
        }
    }
    
    /**
     * When: The view model is initialised
     * And: The meeting point type is NOT `default`
     * Then: Show meeting point should be true
     */
    func testMeetingPointNotDefault() {
        let meetingPoint = TestUtil.getRandomMeetingPoint(type: .meetAndGreet)

        let trip = TestUtil.getRandomTrip(dateSet: true, meetingPoint: meetingPoint)
        testObject = TripDetailsViewModel(trip: trip)
        XCTAssertTrue(testObject.showMeetingPoint)
    }
    
    /**
     * When: The view model is initialised
     * And: The meeting point type is `default`
     * Then: Show meeting point should be false
     */
    func testMeetingPointDefault() {
        let meetingPoint = TestUtil.getRandomMeetingPoint(type: .default)
        
        let trip = TestUtil.getRandomTrip(dateSet: true, meetingPoint: meetingPoint)
        testObject = TripDetailsViewModel(trip: trip)
        XCTAssertFalse(testObject.showMeetingPoint)
    }
    
    /**
     * When: The view model is initialised
     * And: The meeting point type is `notSet`
     * Then: Show meeting point should be false
     */
    func testMeetingPointNotSet() {
        let meetingPoint = TestUtil.getRandomMeetingPoint(type: .notSet)
        
        let trip = TestUtil.getRandomTrip(dateSet: true, meetingPoint: meetingPoint)
        testObject = TripDetailsViewModel(trip: trip)
        XCTAssertFalse(testObject.showMeetingPoint)
    }
    
    /**
     * When: The view model is initialised
     * And: The meeting point type is nil
     * Then: Show meeting point should be false
     */
    func testMeetingPointNil() {
        let trip = TestUtil.getRandomTrip(dateSet: true, meetingPoint: nil)
        testObject = TripDetailsViewModel(trip: trip)
        XCTAssertFalse(testObject.showMeetingPoint)
    }
}
