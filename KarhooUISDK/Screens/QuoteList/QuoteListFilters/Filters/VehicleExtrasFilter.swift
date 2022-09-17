//
//  VehicleExtrasFilter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 16/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit

extension QuoteListFilters {
    enum VehicleExtras: String, UserSelectable, CaseIterable, QuoteListFilter {
        case childSeat = "child-seat"
        case wheelchair

        var filterCategory: Category { .vehicleExtras }
        
        var icon: UIImage? {
            switch self {
            case .childSeat:
                return .uisdkImage("kh_baby_carriage")
            case .wheelchair:
                return .uisdkImage("kh_wheelchair")
            }
        }

        var localizedString: String {
            switch self {
            case .childSeat: return UITexts.VehicleTag.childseat
            case .wheelchair: return UITexts.VehicleTag.wheelchair
            }
        }

        func conditionMet(for quote: Quote) -> Bool {
            quote.vehicle.tags
                .map { $0.lowercased() }
                .contains(rawValue)
        }
    }
}
