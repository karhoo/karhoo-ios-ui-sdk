//
//  VehicleClassFilter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 16/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

extension QuoteListFilters {
    enum VehicleClass: String, UserSelectable, CaseIterable, QuoteListFilter {
        case executive
        case luxury

        var filterCategory: Category { .vehicleClass }

        func conditionMet(for quote: Quote) -> Bool {
            quote.vehicle.vehicleClass.lowercased() == rawValue
        }
    }
}

