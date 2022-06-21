//
//  FilterViewBuilder.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 20/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit

struct FilterViewBuilder {
    static func buildView(for filterCategory: QuoteListFilters.Category) -> FilterView {
        switch filterCategory {
        case .luggage: return NumericFilterView(filter: QuoteListFilters.LuggageCapacityModel(value: 0))
        case .passengers: return NumericFilterView(filter: QuoteListFilters.PassengerCapacityModel(value: 1))
        case .vehicleType: return TemporarFilterView()
        case .vehicleClass: return TemporarFilterView()
        case .vehicleExtras: return TemporarFilterView()
        case .ecoFriendly: return TemporarFilterView()
        case .fleetCapabilities: return TemporarFilterView()
        case .serviceAgreements: return TemporarFilterView()
        case .quoteTypes: return TemporarFilterView()
        }
    }

    static func buildFilterViews() -> [UIView] {
        [
        NumericFilterView(filter: QuoteListFilters.PassengerCapacityModel(value: 1)),
        SeparatorView(fixedHeight: UIConstants.Spacing.standard),
        NumericFilterView(filter: QuoteListFilters.LuggageCapacityModel(value: 0)),
        SeparatorView(fixedHeight: UIConstants.Spacing.medium),
        SeparatorView(fixedHeight: UIConstants.Dimension.Border.standardWidth, color: KarhooUI.colors.border),
        SeparatorView()
        ]
    }
}

class TemporarFilterView: UIView, FilterView {
    var filter: QuoteListFilter = QuoteListFilters.PassengerCapacityModel(value: 1)
    func reset() {
    }
}
