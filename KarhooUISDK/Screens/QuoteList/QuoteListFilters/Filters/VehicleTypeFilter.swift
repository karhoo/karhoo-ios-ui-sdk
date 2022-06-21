//
//  VehicleTypeFilter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 16/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

extension QuoteListFilters {
    enum VehicleType: String, QuoteListFilter {
        case all
        case standard
        case bus
        case mvp
        case moto

        var filterCategory: Category { .vehicleType }

        func conditionMet(for quote: Quote) -> Bool {
            if self == .all { return true }
            return quote.vehicle.type.lowercased() == rawValue
        }
    }
}
