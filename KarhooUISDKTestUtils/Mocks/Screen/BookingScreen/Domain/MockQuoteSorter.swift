//
//  MockQuoteSorter.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

@testable import KarhooUISDK
import KarhooSDK

final public class MockQuoteSorter: QuoteSorter {

    public var sortQuotesSet: [Quote]?
    public var orderSet: QuoteListSortOrder?

    public var quotesToReturn: [Quote] = []
    public func sortQuotes(_ quotes: [Quote], by order: QuoteListSortOrder) -> [Quote] {
        sortQuotesSet = quotes
        orderSet = order
        return quotesToReturn
    }
}
