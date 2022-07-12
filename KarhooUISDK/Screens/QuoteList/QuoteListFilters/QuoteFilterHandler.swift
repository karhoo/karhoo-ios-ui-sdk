//
//  QuoteListFilterModelHandler.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 13/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

class KarhooQuoteFilterHandler: QuoteFilterHandler {
    
    var filters: [QuoteListFilter] = []
    private var luggageCount: Int = 0
    private var passengerCount: Int = 1

    /// Filter given input using self.filters variable value
    func filter(
        _ quotes: [Quote]
    ) -> [Quote] {
        filter(quotes, using: filters)
    }

    /// Filter given input using provided fitlers value
    func filter(
        _ quotes: [Quote],
        using filters: [QuoteListFilter]
    ) -> [Quote] {
        quotes.filter { quote in
                filters.allSatisfy { filter in
                    filter.conditionMet(for: quote)
                }
            }
    }
    
    func updateLuggageAndPassengerFilters(_ filters: [QuoteListFilter]) {
        for filter in filters {
            switch filter.filterCategory {
            case .luggage:
                luggageCount = (filter as? QuoteListNumericFilter)?.value ?? 0
            case .passengers:
                passengerCount = (filter as? QuoteListNumericFilter)?.value ?? 1
            default:
                break
            }
        }
    }
}
