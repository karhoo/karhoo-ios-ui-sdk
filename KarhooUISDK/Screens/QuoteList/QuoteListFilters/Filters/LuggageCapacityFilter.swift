//
//  LuggageCapacityFilter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 16/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

extension QuoteListFilters {
    struct LuggageCapacityModel: QuoteListFilter {
        var value: Int
        var minValue: Int { 0 }
        var maxValue: Int { 7 }
        var filterCategory: Category { .luggage }

        func conditionMet(for quote: Quote) -> Bool {
            quote.vehicle.luggageCapacity >= value
        }
    }
}