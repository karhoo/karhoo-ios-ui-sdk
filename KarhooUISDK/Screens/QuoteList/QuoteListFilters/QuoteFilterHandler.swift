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
        _ quotes: [Quote]
    ) -> [Quote] {
        filter(quotes, using: filters)
    }

    /// Filter given input using provided fitlers value
    func filter(
        _ quotes: [Quote],
        using filters: [QuoteListFilter]
    ) -> [Quote] {
        guard filters.isNotEmpty else {
            return quotes
        }
        let segregatedFitlers = segregate(filters)
        let filteredQuotes = filter(quotes, using: segregatedFitlers)
        return filteredQuotes
    }

    private func segregate(_ filters: [QuoteListFilter]) -> [QuoteListFilters.Category: [QuoteListFilter]] {
        var segregatedFilters: [QuoteListFilters.Category: [QuoteListFilter]] = [:]
        filters.forEach { filter in
            if segregatedFilters[filter.filterCategory] != nil {
                segregatedFilters[filter.filterCategory]?.append(filter)
            } else {
                segregatedFilters[filter.filterCategory] = [filter]
            }
        }
        return segregatedFilters
    }

    private func filter(
        _ quotes: [Quote],
        using segregatedFilters: [QuoteListFilters.Category: [QuoteListFilter]]
    ) -> [Quote] {
        quotes.filter { quoteToFilter in
            let quoteMeetsFilteringConditions: [Bool] = segregatedFilters.map { filters in
                
                switch filters.key {
                case .vehicleExtras, .fleetCapabilities, .serviceAgreements:
                    let categoryFitlerConditionNotMet = filters.value.first { filterOfGivenCategory in
                        !filterOfGivenCategory.conditionMet(for: quoteToFilter)
                    }
                    return categoryFitlerConditionNotMet == nil
                default:
                    let categoryFitlerConditionMet = filters.value.first { filterOfGivenCategory in
                        filterOfGivenCategory.conditionMet(for: quoteToFilter)
                    }
                    return categoryFitlerConditionMet != nil
                }
            }
            // If filtering results do not contain false result, return success (quote meets all filtering conditions)
            return quoteMeetsFilteringConditions.contains(false) == false
        }
    }
}
