//
//  PrebookConfirmationViewModelSpes.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest
import KarhooSDK

@testable import KarhooUISDK

final class PrebookConfirmationViewModelSpec: XCTestCase {

    private var mockQuote: Quote!
    private var mockJourneyDetails: JourneyDetails!
    private var mockDateFormatterType: MockDateFormatterType!
    private var testObject: PrebookConfirmationViewModel!

    override func setUp() {
        super.setUp()
        mockQuote = TestUtil.getRandomQuote()
        mockBookingDetails = TestUtil.getRandomBookingDetails()
        mockDateFormatterType = MockDateFormatterType()
        testObject = PrebookConfirmationViewModel(bookingDetails: mockBookingDetails,
                                                  quote: mockQuote,
                                                  dateFormatter: mockDateFormatterType)
    }

    /**
     * When: The view model inits
     * Then: the properties should be set
     */
    func testViewModelInitialised() {
        XCTAssertEqual(UITexts.Booking.prebookConfirmed, testObject.title)
        XCTAssertEqual(mockBookingDetails.originLocationDetails?.address.displayAddress, testObject.originLocation)
        XCTAssertEqual(mockBookingDetails.destinationLocationDetails?.address.displayAddress ?? "",
                       testObject.destinationLocation)
        XCTAssertEqual(mockBookingDetails.originLocationDetails?.timezone(), mockDateFormatterType.timeZoneSet)
        XCTAssertEqual(mockDateFormatterType.clockTimeReturnString, testObject.time)
        XCTAssertEqual(mockDateFormatterType.shortDateReturnString, testObject.date)
        XCTAssertEqual(CurrencyCodeConverter.toPriceString(quote: mockQuote), testObject.price)
        XCTAssertEqual(mockQuote.quoteType.description, testObject.priceTitle)
        XCTAssertEqual(UITexts.Booking.prebookConfirmedRideDetails, testObject.buttonTitle)
    }
}
