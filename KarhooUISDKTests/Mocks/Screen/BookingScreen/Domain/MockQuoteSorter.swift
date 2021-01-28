//
//  MockQuoteSorter.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK
@testable import KarhooUISDK

final class MockQuoteSorter: QuoteSorter {

    private(set) var sortQuotesSet: [Quote]?
    private(set) var orderSet: QuoteSortOrder?

    var quotesToReturn: [Quote] = []
    func sortQuotes(_ quotes: [Quote], by order: QuoteSortOrder) -> [Quote] {
        return quotesToReturn
    }
}
