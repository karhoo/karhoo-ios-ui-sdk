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

        var icon: UIImage? {
            switch self {
            case .executive:
                return .uisdkImage("u_briefcase")
            case .luxury:
                return .uisdkImage("fi_star")
            }
        }

        var localizedString: String {
            switch self {
            case .executive: return UITexts.VehicleTag.executive
            case .luxury: return UITexts.VehicleClass.luxury
            }
        }
        
        func conditionMet(for quote: Quote) -> Bool {
            quote.vehicle.vehicleClass.lowercased() == rawValue
        }
    }
}
