//
//  KarhooQuoteSorter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

enum QuoteListSortOrder: UserSelectable, CaseIterable {
    case price, qta

    var localizedString: String {
        switch self {
        case .price: return UITexts.Generic.price
        case .qta: return UITexts.Quotes.driverArrivalTime
        }
    }
}

protocol QuoteSorter {
    func sortQuotes(_ quotes: [Quote], by order: QuoteListSortOrder) -> [Quote]
}

final class KarhooQuoteSorter: QuoteSorter {

    func sortQuotes(_ quotes: [Quote], by order: QuoteListSortOrder) -> [Quote] {
        switch order {
        case .price:
            return sortQuotesByPrice(quotes)
        case .qta:
            return sortQuotesByQta(quotes)
        }
    }

    private func sortQuotesByPrice(_ quotes: [Quote]) -> [Quote] {
        return quotes.sorted(by: {(quoteA: Quote, quoteB: Quote) in
            guard quoteA.price.highPrice == quoteB.price.highPrice else {
                return quoteA.price.highPrice < quoteB.price.highPrice
            }

            return quoteA.vehicle.qta.highMinutes < quoteB.vehicle.qta.highMinutes

        })
    }

    private func sortQuotesByQta(_ quotes: [Quote]) -> [Quote] {
        return quotes.sorted(by: { (quoteA: Quote, quoteB: Quote) in
            guard quoteA.vehicle.qta.highMinutes == quoteB.vehicle.qta.highMinutes else {
                return quoteA.vehicle.qta.highMinutes < quoteB.vehicle.qta.highMinutes
            }

            return quoteA.vehicle.qta.highMinutes < quoteB.vehicle.qta.highMinutes
        })
    }
}
