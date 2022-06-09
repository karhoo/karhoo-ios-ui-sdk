//
//  TripExtSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest
@testable import KarhooUISDK
import KarhooSDK

class TripExt: KarhooTestCase {

    /**
     * Given: getting formatted fare
     * When: there is a valid fare
     * Then: expected price string should be returned
     */
    func testGetFareString() {
        let testFare = TestUtil.getRandomTripFare()
        let testTrip = TestUtil.getRandomTrip(fare: testFare)

        XCTAssertEqual(testTrip.farePrice(),
                       CurrencyCodeConverter.toPriceString(price: testFare.total,
                                                           currencyCode: testFare.currency))
    }

    /**
     * Given: getting formatted fare
     * When: there is NOT a valid fare in the trip
     * Then: expected pending should be returned
     */
    func testGetFareStringNoFareInTrip() {
        let testTrip = TestUtil.getRandomTrip(fare: TripFare())

        XCTAssertEqual(testTrip.farePrice(), UITexts.Bookings.priceCancelled)
    }

    /**
     * Given: getting formatted quote
     * When: there is a valid quote
     * Then: expected price string should be returned
     */
    func testGetQuoteString() {
        let testTrip = TestUtil.getRandomTrip()

        XCTAssertEqual(testTrip.quotePrice(),
                       CurrencyCodeConverter.toPriceString(price: testTrip.tripQuote.total,
                                                           currencyCode: testTrip.tripQuote.currency))
    }
}
