//
//  VehicleExtrasFilter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 16/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

extension QuoteListFilters {
    enum VehicleExtras: String, UserSelectable, CaseIterable, QuoteListFilter {
        case taxi
        case childSeat = "child-seat"
        case wheelchair

        var filterCategory: Category { .vehicleExtras }
        
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

