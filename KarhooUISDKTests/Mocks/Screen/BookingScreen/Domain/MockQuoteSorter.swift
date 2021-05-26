//
//  MockQuoteSorter.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

@testable import KarhooUISDK
import KarhooSDK

final class MockQuoteSorter: QuoteSorter {

    private(set) var sortQuotesSet: [Quote]?
    private(set) var orderSet: QuoteSortOrder?

    var quotesToReturn: [Quote] = []
    func sortQuotes(_ quotes: [Quote], by order: QuoteSortOrder) -> [Quote] {
        sortQuotesSet = quotes
        orderSet = order
        return quotesToReturn
    }
}
