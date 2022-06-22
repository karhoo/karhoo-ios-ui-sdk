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
    var filters: [QuoteListFilter]
    
    func buildFilterViews() -> [UIView] {
        [
            buildPassengersFilterView(),
            SeparatorView(fixedHeight: UIConstants.Spacing.standard),
            buildLuggagesFilterView(),
            SeparatorView(fixedHeight: UIConstants.Spacing.medium),
            SeparatorView(fixedHeight: UIConstants.Dimension.Border.standardWidth, color: KarhooUI.colors.border),
            SeparatorView()
        ]
    }

    private func buildPassengersFilterView() -> UIView {
        let filter = (filters.first { $0.filterCategory == .passengers } as? QuoteListNumericFilter) ?? QuoteListFilters.PassengerCapacityModel(value: 1)
        return NumericFilterView(filter: filter)
    }
    
    private func buildLuggagesFilterView() -> UIView {
        let filter = (filters.first { $0.filterCategory == .luggage } as? QuoteListNumericFilter) ?? QuoteListFilters.LuggageCapacityModel(value: 0)
        return NumericFilterView(filter: filter)
    }
}

class TemporarFilterView: UIView, FilterView {
    var onFilterChanged: ((QuoteListFilter) -> Void)?
    
    var filter: QuoteListFilter = QuoteListFilters.PassengerCapacityModel(value: 1)
    func reset() {
    }
}
