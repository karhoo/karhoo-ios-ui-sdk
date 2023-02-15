//
//  CurrencyCodeConverterSpec.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooSDK
import KarhooUISDKTestUtils
@testable import KarhooUISDK

class CurrencyCodeConverterSpec: KarhooTestCase {

    /**
     *  Given:  A valid currency code in the quote
     *  And:    A valid price in quote
     *  When:   Converting to a price string
     *  Then:   The string should have the correct currency code and price value
     */
    func testConvertingQuoteToPrice() {
        let quote = TestUtil.getRandomQuote(highPrice: 9123, currencyCode: "GBP")
        let priceString = CurrencyCodeConverter.toPriceString(quote: quote)

        XCTAssertEqual("£91.23", priceString)
    }

    /**
     *  Given:  A valid currency code in the quote with JOD currency code
     *  And:    A valid price in quote with 3 decimals
     *  When:   Converting to a price string
     *  Then:   The string should have the correct currency code and price value
     */
    func testConvertingQuoteToPriceForJOD() {
        let quote = TestUtil.getRandomQuote(highPrice: 9123, currencyCode: "JOD")
        let priceString = CurrencyCodeConverter.toPriceString(quote: quote)

        XCTAssertEqual("JOD 9.123", priceString)
    }
    
    /**
     *  Given:  A valid currency code in the quote with JPY currency code
     *  And:    A valid price in quote with 0 decimals, For example, 10 GBP is submitted as 1000, whereas 10 JPY is submitted as 10.
     *  When:   Converting to a price string
     *  Then:   The string should have the correct currency code and price value
     */
    func testConvertingQuoteToPriceForJPY() {
        let quote = TestUtil.getRandomQuote(highPrice: 91, currencyCode: "JPY")
        let priceString = CurrencyCodeConverter.toPriceString(quote: quote)

//        XCTAssertEqual("¥91", priceString)
    }
    
    /**
     *  Given:  Price and currency code are valid
     *  When:   Converting to string
     *  Then:   Correct string should be returned
     */
    func testConvertingRawToPrice() {
        let price = 3423
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
     *  Given:  Quote with zero price in JPY
     *  When:   Converting to a price string
     *  Then:   Empty string should be returned
     */
    func testConvertingZeroPriceQuoteInJPY() {
        let quote = TestUtil.getRandomQuote(highPrice: 0, currencyCode: "JPY")
        let priceString = CurrencyCodeConverter.toPriceString(quote: quote)

//        XCTAssertEqual("¥0", priceString)
    }

    /**
     *  Given:  Quote with zero price in JOD
     *  When:   Converting to a price string
     *  Then:   Empty string should be returned
     */
    func testConvertingZeroPriceQuoteInJOD() {
        let quote = TestUtil.getRandomQuote(highPrice: 0, currencyCode: "JOD")
        let priceString = CurrencyCodeConverter.toPriceString(quote: quote)

        XCTAssertEqual("JOD 0.000", priceString)
    }

    /**
     *  Given:  A quote with invalid currecy code
     *  When:   Converting to a price string
     *  Then:   Currency code should be set infront of price anyway
     */
    func testInvlalidCurrencyCode() {
        let quote = TestUtil.getRandomQuote(highPrice: 9000, currencyCode: "XXX")
        let priceString = CurrencyCodeConverter.toPriceString(quote: quote)

        XCTAssertEqual("¤90.00", priceString)
    }

    /**
     *  When:   Showing a quote range
     *  Then:   Expected price should show
     */
    func testQuoteRange() {
        let quote = TestUtil.getRandomQuote(highPrice: 5000, lowPrice: 1000, currencyCode: "GBP")
        let priceString = CurrencyCodeConverter.quoteRangePrice(quote: quote)

        XCTAssertEqual("£10.00 - £50.00", priceString)
    }
    
    /**
     *  When:   Showing a quote range for JPY
     *  Then:   Expected price should show
     */
    func testQuoteRangeForJPY() {
        let quote = TestUtil.getRandomQuote(highPrice: 50, lowPrice: 10, currencyCode: "JPY")
        let priceString = CurrencyCodeConverter.quoteRangePrice(quote: quote)

//        XCTAssertEqual("¥10 - ¥50", priceString)
    }
    
    /**
     *  When:   Showing a quote range for JOD
     *  Then:   Expected price should show
     */
    func testQuoteRangeForJOD() {
        let quote = TestUtil.getRandomQuote(highPrice: 5321, lowPrice: 1321, currencyCode: "JOD")
        let priceString = CurrencyCodeConverter.quoteRangePrice(quote: quote)

        XCTAssertEqual("JOD 1.321 - JOD 5.321", priceString)
    }
}
