//
//  QuoteTypeFilter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 16/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

extension QuoteListFilters {
    enum QuoteType: String, UserSelectable, CaseIterable, QuoteListFilter {
        case fixed
        case metered

        var filterCategory: Category { .quoteTypes}
        
        var localizedString: String {
            switch self {
            case .fixed:
                return KarhooSDK.QuoteType.fixed.description
            case .metered:
                return KarhooSDK.QuoteType.metered.description
            }
        }

        func conditionMet(for quote: Quote) -> Bool {
            switch self {
            case .fixed: return quote.quoteType == .fixed
            case .metered: return [.metered, .estimated].contains(quote.quoteType)
            }
        }
    }
}

