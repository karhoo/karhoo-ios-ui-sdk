//
//  VehicleClassFilter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 16/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit

extension QuoteListFilters {
    enum VehicleClass: String, UserSelectable, CaseIterable, QuoteListFilter {
        case standard
        case executive
        case luxury

        var filterCategory: Category { .vehicleClass }

        var icon: UIImage? {
            switch self {
            case .executive:
                return .uisdkImage("kh_uisdk_briefcase")
            case .luxury:
                return .uisdkImage("kh_uisdk_star_empty")
            case .standard:
                return .uisdkImage("kh_uisdk_car")
            }
        }

        var localizedString: String {
            switch self {
            case .executive: return UITexts.VehicleTag.executive
            case .luxury: return UITexts.VehicleClass.luxury
            case .standard: return UITexts.VehicleClass.standard
            }
        }
        
        func conditionMet(for quote: Quote) -> Bool {
            switch self {
            case .standard:
                let tags = quote.vehicle.tags.map { $0.lowercased() }
                let forbidTags = [VehicleClass.executive.rawValue, VehicleClass.luxury.rawValue]
                return !tags.contains { forbidTags.contains($0) }
            default:
                return quote.vehicle.tags.map { $0.lowercased() }.contains(rawValue)
            }
        }
    }
}
