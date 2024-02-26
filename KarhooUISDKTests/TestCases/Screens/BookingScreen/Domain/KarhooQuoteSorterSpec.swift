//
//  KarhooQuoteSorterSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK
import KarhooUISDKTestUtils
import XCTest
@testable import KarhooUISDK

final class KarhooQuoteSorterSpec: KarhooTestCase {

    private var testObject = KarhooQuoteSorter()

    /**
     *  When:   Ordering by price
     *  Then:   quoteA should come ahead of quoteB
     */
    func testQuoteOrderByPrice() {
        let quoteA = TestUtil.getRandomQuote(highPrice: 2, lowPrice: 2)
        let quoteB = TestUtil.getRandomQuote(highPrice: 4, lowPrice: 4)
        let quotes = [quoteB, quoteA]

        let quotesInAscendingOrderByPrice = testObject.sortQuotes(quotes, by: .price)

        XCTAssertTrue(quotesInAscendingOrderByPrice[0] == quoteA)
        XCTAssertTrue(quotesInAscendingOrderByPrice[1] == quoteB)
    }

    /**
     *  When:   Ordering by QTA
     *  Then:   quoteA should come ahead of quoteB
     */
    func testQuoteOrderByQTA() {
        let quoteA = TestUtil.getRandomQuote(qtaHighMinutes: 2)
        let quoteB = TestUtil.getRandomQuote(qtaHighMinutes: 5)
        let quotes = [quoteB, quoteA]

        let quotesInAscendingOrderByQta = testObject.sortQuotes(quotes, by: .qta)

        XCTAssertTrue(quotesInAscendingOrderByQta[0] == quoteA)
        XCTAssertTrue(quotesInAscendingOrderByQta[1] == quoteB)
    }

    /**
     *  Given:  Quotes with the same price, but different QTAs
     *  When:   Ordering by price
     *  Then:   It should order by min Qta (quoteA should be ahead of quoteB)
     */
    func testOrderByPriceSamePriceDifferentQta() {
        let quoteA = TestUtil.getRandomQuote(highPrice: 10, qtaHighMinutes: 5)
        let quoteB = TestUtil.getRandomQuote(highPrice: 10, qtaHighMinutes: 10)
        let quotes = [quoteB, quoteA]

        let quotesInAscendingOrderByPrice = testObject.sortQuotes(quotes, by: .price)

        XCTAssertTrue(quotesInAscendingOrderByPrice[0] == quoteA)
        XCTAssertTrue(quotesInAscendingOrderByPrice[1] == quoteB)
    }

    /**
     *  Given:  Quotes with the same Qta, but different prices
     *  When:   Ordering by Qta
     *  Then:   It should order by price
     */
    func testOrderByQtaSameQtaDifferentPrice() {
        let quoteA = TestUtil.getRandomQuote(highPrice: 50, qtaHighMinutes: 10)
        let quoteB = TestUtil.getRandomQuote(highPrice: 100, qtaHighMinutes: 10)
        let quotes = [quoteA, quoteB]

        let quotesInAscendingOrderByQta = testObject.sortQuotes(quotes, by: .qta)

        XCTAssertTrue(quotesInAscendingOrderByQta[0] == quoteA)
        XCTAssertTrue(quotesInAscendingOrderByQta[1] == quoteB)
    }
}
