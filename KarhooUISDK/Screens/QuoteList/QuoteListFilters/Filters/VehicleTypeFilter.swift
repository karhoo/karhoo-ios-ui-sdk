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
    enum VehicleType: String, QuoteListFilter, CaseIterable {
        case standard
        case bus
        case mpv
        case moto

        var filterCategory: Category { .vehicleType }

        var localizedString: String {
            switch self {
            case .moto:
                return UITexts.VehicleType.moto
            case .standard:
                return UITexts.VehicleType.standard
            case .mpv:
                return UITexts.VehicleType.mpv
            case .bus:
                return UITexts.VehicleType.bus
            }
        }

        func conditionMet(for quote: Quote) -> Bool {
            quote.vehicle.type.lowercased() == rawValue
        }
    }
}
