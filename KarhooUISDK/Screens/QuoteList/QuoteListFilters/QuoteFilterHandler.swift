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

    /// Filter given input using self.filters variable value
    func filter(
        _ quotes: Quotes
    ) -> [Quote] {
        filter(quotes, using: filters)
    }

    /// Filter given input using provided fitlers value
    func filter(
        _ quotes: Quotes,
        using filters: [QuoteListFilter]
    ) -> [Quote] {
        quotes.all
            .filter { quote in
                filters.allSatisfy { filter in
                    filter.conditionMet(for: quote)
                }
            }
    }
}
