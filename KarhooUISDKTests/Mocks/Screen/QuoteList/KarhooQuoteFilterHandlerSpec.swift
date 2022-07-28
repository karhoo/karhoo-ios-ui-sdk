//
//  KarhooQuoteFilterHandlerSpec.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 15/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import XCTest
import KarhooSDK
@testable import KarhooUISDK

class KarhooQuoteFilterHandlerSpec: KarhooTestCase {
    
    var sut: KarhooQuoteFilterHandler!

    override func setUp() {
        super.setUp()
        sut = KarhooQuoteFilterHandler()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testFiltersFiltering1() {
        let filters: [QuoteListFilter] = [
            QuoteListFilters.QuoteType.fixed,
            QuoteListFilters.VehicleClass.executive
        ]
        let quotesToFilter: [Quote] = [
            Quote(quoteType: .fixed, vehicle: .init(tags: ["EXECUTIVE"])),
            Quote(quoteType: .fixed, vehicle: .init(tags: ["executive"]))
        ]
        let filteredQuotes = sut.filter(quotesToFilter, using: filters)
        
        XCTAssert(filteredQuotes.count == quotesToFilter.count, "filtered results: \(filteredQuotes.count), expected: \(quotesToFilter.count)")
    }

    func testFiltersFiltering2() {
        let filters: [QuoteListFilter] = [
            QuoteListFilters.QuoteType.metered,
            QuoteListFilters.VehicleClass.executive
        ]
        let quotesToFilter: [Quote] = [
            Quote(quoteType: .fixed, vehicle: .init(vehicleClass: "EXECUTIVE")),
            Quote(quoteType: .fixed, vehicle: .init(vehicleClass: "EXECUTIVE"))
        ]
        let filteredQuotes = sut.filter(quotesToFilter, using: filters)
        
        XCTAssert(filteredQuotes.isEmpty)
    }

    /// Test AND categories success
    func testFiltersFiltering3() {
        let filters: [QuoteListFilter] = [
            QuoteListFilters.VehicleExtras.wheelchair,
            QuoteListFilters.VehicleExtras.childSeat
        ]
        let quotesToFilter: [Quote] = [
            Quote(quoteType: .fixed, vehicle: .init(tags: ["wheelchair", "child-seat"])),
            Quote(quoteType: .fixed, vehicle: .init(tags: ["wheelchair", "child-seat"]))
        ]
        let filteredQuotes = sut.filter(quotesToFilter, using: filters)
        XCTAssert(filteredQuotes.count == quotesToFilter.count, "filtered results: \(filteredQuotes.count), expected: \(quotesToFilter.count)")
    }

    /// Test AND categories failure
    func testFiltersFiltering4() {
        let filters: [QuoteListFilter] = [
            QuoteListFilters.VehicleExtras.wheelchair,
            QuoteListFilters.VehicleExtras.childSeat
        ]
        let quotesToFilter: [Quote] = [
            Quote(quoteType: .fixed, vehicle: .init(tags: ["child-seat"])),
            Quote(quoteType: .fixed, vehicle: .init(tags: ["wheelchair"]))
        ]
        let filteredQuotes = sut.filter(quotesToFilter, using: filters)
        XCTAssert(filteredQuotes.isEmpty)
    }
}
