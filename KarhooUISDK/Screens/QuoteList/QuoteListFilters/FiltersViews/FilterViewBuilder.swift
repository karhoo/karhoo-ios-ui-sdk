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
            buildLineSeparator(),
            SeparatorView(fixedHeight: UIConstants.Spacing.medium),
            buildVehicleTypeFilterView(),
            SeparatorView(fixedHeight: UIConstants.Spacing.medium),
            buildLineSeparator(),
            SeparatorView(fixedHeight: UIConstants.Spacing.xLarge),
            buildVehicleClassFilterView(),
            SeparatorView(fixedHeight: UIConstants.Spacing.medium),
            buildLineSeparator(),
            SeparatorView(fixedHeight: UIConstants.Spacing.xLarge),
            buildVehicleExtrasFilterView(),
            SeparatorView(fixedHeight: UIConstants.Spacing.medium),
            buildLineSeparator(),
            SeparatorView(fixedHeight: UIConstants.Spacing.xLarge),
            buildEcoFriendlyFilterView(),
            SeparatorView(fixedHeight: UIConstants.Spacing.medium),
            buildLineSeparator(),
            SeparatorView(fixedHeight: UIConstants.Spacing.xLarge),
            buildFleetCapabilitiesFilterView(),
            SeparatorView()
        ]
    }

    private func buildLineSeparator() -> UIView {
        SeparatorView(fixedHeight: UIConstants.Dimension.Border.standardWidth, color: KarhooUI.colors.border)
    }

    private func buildPassengersFilterView() -> UIView {
        let filter = (filters.first { $0.filterCategory == .passengers } as? QuoteListNumericFilter) ?? QuoteListFilters.PassengerCapacityModel(value: 1)
        return NumericFilterView(filter: filter)
    }
    
    private func buildLuggagesFilterView() -> UIView {
        let filter = (filters.first { $0.filterCategory == .luggage } as? QuoteListNumericFilter) ?? QuoteListFilters.LuggageCapacityModel(value: 0)
        return NumericFilterView(filter: filter)
    }

    private func buildVehicleTypeFilterView() -> UIView {
        let selectedFilters = filters.filter { $0.filterCategory == .vehicleType }
        return ItemsFilterView(
            title: QuoteListFilters.Category.vehicleType.localized,
            selectableFilters: QuoteListFilters.VehicleType.allCases,
            selectedFilters: selectedFilters
        )
    }

    private func buildVehicleClassFilterView() -> UIView {
        let selectedFilters = filters.filter { $0.filterCategory == .vehicleClass }
        return ItemsFilterView(
            title: QuoteListFilters.Category.vehicleClass.localized,
            selectableFilters: QuoteListFilters.VehicleClass.allCases,
            selectedFilters: selectedFilters
        )
    }

    private func buildVehicleExtrasFilterView() -> UIView {
        let selectedFilters = filters.filter { $0.filterCategory == .vehicleExtras }
        return ItemsFilterView(
            title: QuoteListFilters.Category.vehicleExtras.localized,
            selectableFilters: QuoteListFilters.VehicleExtras.allCases,
            selectedFilters: selectedFilters
        )
    }

    private func buildEcoFriendlyFilterView() -> UIView {
        let selectedFilters = filters.filter { $0.filterCategory == .ecoFriendly }
        return ItemsFilterView(
            title: QuoteListFilters.Category.ecoFriendly.localized,
            selectableFilters: QuoteListFilters.EcoFriendly.allCases,
            selectedFilters: selectedFilters
        )
    }

    private func buildFleetCapabilitiesFilterView() -> UIView {
        let selectedFilters = filters.filter { $0.filterCategory == .fleetCapabilities }
        return ItemsFilterView(
            title: QuoteListFilters.Category.fleetCapabilities.localized,
            selectableFilters: QuoteListFilters.FleetCapabilities.allCases,
            selectedFilters: selectedFilters
        )
    }
}

class TemporarFilterView: UIView, FilterView {
    var onFilterChanged: (([QuoteListFilter]) -> Void)?
    
    var filter: [QuoteListFilter] = [QuoteListFilters.PassengerCapacityModel(value: 1)]
    func reset() {
    }
}
