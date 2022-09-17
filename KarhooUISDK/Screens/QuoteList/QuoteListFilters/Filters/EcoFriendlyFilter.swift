//
//  EcoFriendlyFilter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 16/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit

extension QuoteListFilters {
    enum EcoFriendly: String, QuoteListFilter, CaseIterable {
        case electric
        case hybrid

        var filterCategory: Category { .ecoFriendly }
        
        var icon: UIImage? {
            switch self {
            case .electric:
                return .uisdkImage("kh_electric")
            case .hybrid:
                return .uisdkImage("kh_hybrid")
            }
        }
        
        var localizedString: String {
            switch self {
            case .electric: return UITexts.VehicleTag.electric
            case .hybrid: return UITexts.VehicleTag.hybrid
            }
        }

        func conditionMet(for quote: Quote) -> Bool {
            quote.vehicle.tags
                .map { $0.lowercased() }
                .contains(rawValue)
        }
    }
}

