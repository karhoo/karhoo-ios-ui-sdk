//
//  JourneyOptionsViewModelSpec.swift
//  KarhooTests
//
//  Created by Jeevan Thandi on 10/11/2018.
//  Copyright © 2018 Flit Technologies LTD. All rights reserved.
//

import XCTest
import KarhooSDK
@testable import Karhoo

final class JourneyOptionsViewModelSpec: XCTestCase {

    private var testObject: JourneyOptionsViewModel!

    override func setUp() {
        super.setUp()
    }

    /**
      * When: The passenger is onboard
      * Then: Call Fleet should be the contact option and cancel ride is disabled
      */
    func testPassengerOnboard() {
        let mockTrip = TestUtil.getRandomTrip(state: .passengerOnBoard)

        testObject = JourneyOptionsViewModel(trip: mockTrip)

        XCTAssertEqual(Texts.Journey.journeyContactFleet, testObject.tripContactInfo)
        XCTAssertEqual(mockTrip.fleetInfo.phoneNumber, testObject.tripContactNumber)
    }

    /**
     * When: Supplier can be contacted BUT driver cannot
     * Then: Then trip contact info should be that of the fleets
     */
    func testDriverCannotBeContacted() {
        let driver = TestUtil.getRandomDriver(phoneNumber: "")
        let vehicle = TestUtil.getRandomVehicle(driver: driver)
        let mockTrip = TestUtil.getRandomTrip(state: .driverEnRoute,
                                              vehicle: vehicle)

        testObject = JourneyOptionsViewModel(trip: mockTrip)

        XCTAssertEqual(Texts.Journey.journeyContactFleet, testObject.tripContactInfo)
        XCTAssertEqual(mockTrip.fleetInfo.phoneNumber, testObject.tripContactNumber)
    }

    /**
     * When: Driver can be contacted
     * Then: Then trip contact info should be that of the driver
     */
    func testCanContactDriver() {
        let driver = TestUtil.getRandomDriver(phoneNumber: "12345")
        let vehicle = TestUtil.getRandomVehicle(driver: driver)
        let mockTrip = TestUtil.getRandomTrip(state: .driverEnRoute,
                                              vehicle: vehicle)

        testObject = JourneyOptionsViewModel(trip: mockTrip)

        XCTAssertEqual(Texts.Journey.journeyContactDriver, testObject.tripContactInfo)
        XCTAssertEqual("12345", testObject.tripContactNumber)
    }

    /**
     * When: The trip can be cancelled
     * Then: View should enable cancel button
     */
    func testCanCancelTripSetup() {
        let cancellableStates = [TestUtil.getRandomTrip(state: .requested),
                                 TestUtil.getRandomTrip(state: .confirmed),
                                 TestUtil.getRandomTrip(state: .driverEnRoute),
                                 TestUtil.getRandomTrip(state: .arrived)]

        cancellableStates.forEach({ trip in
            testObject = JourneyOptionsViewModel(trip: trip)

            XCTAssertTrue(testObject.cancelEnabled)
        })
    }

    /**
     * When: The trip cant be cancelled
     * Then: View should not enable cancel button
     */
    func testCantCancelTripSetup() {
        let nonCancelStates = [TestUtil.getRandomTrip(state: .passengerOnBoard),
                               TestUtil.getRandomTrip(state: .completed),
                               TestUtil.getRandomTrip(state: .noDriversAvailable),
                               TestUtil.getRandomTrip(state: .unknown),
                               TestUtil.getRandomTrip(state: .driverCancelled),
                               TestUtil.getRandomTrip(state: .bookerCancelled)]

        nonCancelStates.forEach({ trip in
            testObject = JourneyOptionsViewModel(trip: trip)

            XCTAssertFalse(testObject.cancelEnabled)
        })
    }
}
