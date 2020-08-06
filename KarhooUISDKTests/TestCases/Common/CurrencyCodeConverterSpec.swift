//
//  CurrencyCodeConverterSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooSDK
@testable import KarhooUISDK

class CurrencyCodeConverterSpec: XCTestCase {

    /**
     *  Given:  A valid currency code in the quote
     *  And:    A valid price in quote
     *  When:   Converting to a price string
     *  Then:   The string should have the correct currency code and price value
     */
    func testConvertingQuoteToPrice() {
        let quote = TestUtil.getRandomQuote(highPrice: 90, currencyCode: "GBP")
        let priceString = CurrencyCodeConverter.toPriceString(quote: quote)

        XCTAssertEqual("£90.00", priceString)
    }

    /**
     *  Given:  Price and currency code are valid
     *  When:   Converting to string
     *  Then:   Correct string should be returned
     */
    func testConvertingRawToPrice() {
        let price = 34.23
        let code = "GBP"

        let result = CurrencyCodeConverter.toPriceString(price: price, currencyCode: code)
        XCTAssertEqual("£34.23", result)
    }

    /**
     *  Given:  Quote with zero price
     *  When:   Converting to a price string
     *  Then:   Empty string should be returned
     */
    func testConvertingZeroPriceQuote() {
        let quote = TestUtil.getRandomQuote(highPrice: 0, currencyCode: "GBP")
        let priceString = CurrencyCodeConverter.toPriceString(quote: quote)

        XCTAssertEqual("£0.00", priceString)
    }

    /**
     *  Given:  A quote with invalid currecy code
     *  When:   Converting to a price string
     *  Then:   Currency code should be set infront of price anyway
     */
    func testInvlalidCurrencyCode() {
        let quote = TestUtil.getRandomQuote(highPrice: 90, currencyCode: "XXX")
        let priceString = CurrencyCodeConverter.toPriceString(quote: quote)

        XCTAssertEqual("XXX90.00", priceString)
    }

    /**
     *  When:   Showing a quote range
     *  Then:   Expected price should show
     */
    func testQuoteRange() {
        let quote = TestUtil.getRandomQuote(highPrice: 50, lowPrice: 10, currencyCode: "GBP")
        let priceString = CurrencyCodeConverter.quoteRangePrice(quote: quote)

        XCTAssertEqual("£10.00 - £50.00", priceString)
    }
}
