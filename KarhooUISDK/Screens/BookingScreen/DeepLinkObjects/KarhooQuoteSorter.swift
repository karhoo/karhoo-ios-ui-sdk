//
//  KarhooQuoteSorter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

enum QuoteSortOrder {
    case price, qta
}

protocol QuoteSorter {
    func sortQuotes(_ quotes: [Quote], by order: QuoteSortOrder) -> [Quote]
}

final class KarhooQuoteSorter: QuoteSorter {

    func sortQuotes(_ quotes: [Quote], by order: QuoteSortOrder) -> [Quote] {
        switch order {
        case .price:
            return sortQuotesByPrice(quotes)
        case .qta:
            return sortQuotesByQta(quotes)
        }
    }

    private func sortQuotesByPrice(_ quotes: [Quote]) -> [Quote] {
        return quotes.sorted(by: {(quoteA: Quote, quoteB: Quote) in
            guard quoteA.highPrice == quoteB.highPrice else {
                return quoteA.highPrice < quoteB.highPrice
            }

            return quoteA.qtaHighMinutes < quoteB.qtaHighMinutes

        })
    }

    private func sortQuotesByQta(_ quotes: [Quote]) -> [Quote] {
        return quotes.sorted(by: { (quoteA: Quote, quoteB: Quote) in
            guard quoteA.qtaHighMinutes == quoteB.qtaHighMinutes else {
                return quoteA.qtaHighMinutes < quoteB.qtaHighMinutes
            }

            return quoteA.highPrice < quoteB.highPrice

        })
    }
}
