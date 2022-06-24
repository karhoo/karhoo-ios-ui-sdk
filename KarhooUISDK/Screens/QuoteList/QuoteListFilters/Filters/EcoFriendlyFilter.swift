//
//  EcoFriendlyFilter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 16/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

extension QuoteListFilters {
    enum EcoFriendly: String, QuoteListFilter, CaseIterable {
        case electric
        case hybrid

        var filterCategory: Category { .ecoFriendly }
        
        var localizedString: String {
            rawValue
        }

        func conditionMet(for quote: Quote) -> Bool {
            quote.vehicle.tags
                .map { $0.lowercased() }
                .contains(rawValue)
        }
    }
}

