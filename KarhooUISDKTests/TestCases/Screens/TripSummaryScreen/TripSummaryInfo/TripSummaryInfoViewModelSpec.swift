//
//  TripSummaryInfoViewModelSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import XCTest
import KarhooSDK
@testable import KarhooUISDKTestUtils
@testable import KarhooUISDK

final class TripSummaryInfoViewModelSpec: KarhooTestCase {

    private var testObject: TripSummaryInfoViewModel!

    /**
     * When: passed a trip
     * Then: expected model should be correct
     */
    func testLoadingViewModel() {
        let testTrip = TestUtil.getRandomTrip(dateSet: true,
                                              state: .completed,
                                              fare: TestUtil.getRandomTripFare())
        testObject = TripSummaryInfoViewModel(trip: testTrip)

        XCTAssertEqual(testObject.pickup, testTrip.origin.displayAddress)
        XCTAssertEqual(testObject.destination, testTrip.destination!.displayAddress)

        let dateFormatter = KarhooDateFormatter(timeZone: testTrip.origin.timezone())

        XCTAssertEqual(testObject.formattedDate,
                       dateFormatter.display(detailStyleDate: testTrip.dateScheduled))
        XCTAssertEqual(testObject.vehicleInformation,
                       "\(testTrip.vehicle.vehicleClass): \(testTrip.vehicle.vehicleLicensePlate)")
        XCTAssertEqual(testObject.supplierName, testTrip.fleetInfo.name)
        XCTAssertEqual(testObject.price, testTrip.farePrice())
        XCTAssertEqual(testObject.priceDescription, UITexts.TripSummary.totalFare)
        XCTAssertEqual(testObject.clientLogo,
                       KarhooUISDKConfigurationProvider.configuration.logo())
    }

    /**
     * When: There is no vehicle class
     * Then: Vehicle Information should be the description and reg plate
     */
    func testNoVehicleInfo() {
        let vehicleWithNoClass = TestUtil.getRandomVehicle(vehicleClass: "")
        let testTrip = TestUtil.getRandomTrip(vehicle: vehicleWithNoClass)

        testObject = TripSummaryInfoViewModel(trip: testTrip)

        XCTAssertEqual(testObject.vehicleInformation,
                       "\(testTrip.vehicle.description): \(testTrip.vehicle.vehicleLicensePlate)")
    }

    /**
     * When: There is no fare
     * Then: Quote should be used
     */
    func testNoFareShowsQuote() {
        let testTrip = TestUtil.getRandomTrip(fare: TripFare())
        testObject = TripSummaryInfoViewModel(trip: testTrip)

        XCTAssertEqual(testObject.price, testTrip.quotePrice())
        XCTAssertEqual(testObject.priceDescription, UITexts.TripSummary.quotedPrice)
    }

    /**
     * When: There is fare with total 0
     * Then: Quote should be used
     */
    func testZeroFareShowsQuote() {
        let fare = TripFare(total: 0, currency: "EUR", gratuityPercent: 0)
        let testTrip = TestUtil.getRandomTrip(fare: fare)
        testObject = TripSummaryInfoViewModel(trip: testTrip)

        XCTAssertEqual(testObject.price, testTrip.quotePrice())
        XCTAssertEqual(testObject.priceDescription, UITexts.TripSummary.quotedPrice)
    }
}
