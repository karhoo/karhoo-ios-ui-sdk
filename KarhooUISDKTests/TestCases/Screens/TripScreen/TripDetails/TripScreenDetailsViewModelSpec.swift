//
//  TripScreenDetailsViewModelSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
@testable import KarhooUISDK

final class TripScreenDetailsViewModelSpec: XCTestCase {

    private var testObject: TripScreenDetailsViewModel!
    private var mockTrip = TestUtil.getRandomTrip()

    override func setUp() {
        super.setUp()

        testObject = TripScreenDetailsViewModel(trip: mockTrip)
    }

    /**
      * When: Initialising with a trip
      * Then: correct properties should be binded
      */
    func testPropertyBinding() {
        XCTAssertEqual(testObject.driverName,
                       "\(mockTrip.vehicle.driver.firstName) \(mockTrip.vehicle.driver.lastName)")
        XCTAssertEqual(testObject.vehicleDescription, mockTrip.vehicle.description)
        XCTAssertEqual(testObject.vehicleLicensePlate, mockTrip.vehicle.vehicleLicensePlate)
        XCTAssertEqual(testObject.driverRegulatoryLicenseNumber, mockTrip.vehicle.driver.licenseNumber)
        XCTAssertEqual(testObject.driverPhotoUrl, mockTrip.vehicle.driver.photoUrl)
    }
}
