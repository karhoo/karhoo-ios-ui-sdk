//
//  FilterViewBuilder.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 20/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit

struct FilterViewBuilder {
    var filters: [QuoteListFilter]
    
    func buildFilterViews() -> [UIView] {
        var result = [UIView]()
        
        for category in QuoteListFilters.Category.sortedAll {
            switch category {
            case .passengers:
                if !isCategoryExcluded(.passengers) {
                    result.append(buildPassengersFilterView())
                    
                    if isCategoryExcluded(.luggage) {
                        result.append(contentsOf: [
                            SeparatorView(fixedHeight: UIConstants.Spacing.xLarge),
                            buildLineSeparator()
                        ])
                    } else {
                        result.append(SeparatorView(fixedHeight: UIConstants.Spacing.standard))
                    }
                }
            case .luggage:
                if !isCategoryExcluded(.luggage) {
                    result.append(contentsOf: [
                        buildLuggagesFilterView(),
                        SeparatorView(fixedHeight: UIConstants.Spacing.xLarge),
                        buildLineSeparator()
                    ])
                }
            default:
                if !isCategoryExcluded(category) {
                    result.append(contentsOf: [
                        SeparatorView(fixedHeight: UIConstants.Spacing.medium),
                        getProperViewFor(category),
                        SeparatorView(fixedHeight: UIConstants.Spacing.xLarge),
                        buildLineSeparator()
                    ])
                }
            }
        }
        
        // Remove the last separator line
        if result.count > 0 {
            result.removeLast()
        }
        
        return result
    }
    
    private func isCategoryExcluded(_ category: QuoteListFilters.Category) -> Bool {
        KarhooUISDKConfigurationProvider.configuration.excludedFilterCategories.contains(category)
    }
    
    private func getProperViewFor(_ category: QuoteListFilters.Category) -> UIView {
        switch category {
        case.passengers:
            return buildPassengersFilterView()
        case .luggage:
            return buildLuggagesFilterView()
        case .vehicleType:
            return buildVehicleTypeFilterView()
        case .vehicleClass:
            return buildVehicleClassFilterView()
        case .vehicleExtras:
            return buildVehicleExtrasFilterView()
        case .ecoFriendly:
            return buildEcoFriendlyFilterView()
        case .fleetCapabilities:
            return buildFleetCapabilitiesFilterView()
        case .quoteTypes:
            return buildQuoteTypesFilterView()
        case .serviceAgreements:
            return buildServiceAgreementsFilterView()
        }
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
            category: .vehicleType,
            selectableFilters: QuoteListFilters.VehicleType.allCases,
            selectedFilters: selectedFilters
        )
    }

    private func buildVehicleClassFilterView() -> UIView {
        let selectedFilters = filters.filter { $0.filterCategory == .vehicleClass }
        return ItemsFilterView(
            category: .vehicleClass,
            selectableFilters: QuoteListFilters.VehicleClass.allCases,
            selectedFilters: selectedFilters
        )
    }

    private func buildVehicleExtrasFilterView() -> UIView {
        let selectedFilters = filters.filter { $0.filterCategory == .vehicleExtras }
        return ItemsFilterView(
            category: .vehicleExtras,
            selectableFilters: QuoteListFilters.VehicleExtras.allCases,
            selectedFilters: selectedFilters
        )
    }

    private func buildEcoFriendlyFilterView() -> UIView {
        let selectedFilters = filters.filter { $0.filterCategory == .ecoFriendly }
        return ItemsFilterView(
            category: .ecoFriendly,
            selectableFilters: QuoteListFilters.EcoFriendly.allCases,
            selectedFilters: selectedFilters
        )
    }

    private func buildFleetCapabilitiesFilterView() -> UIView {
        let selectedFilters = filters.filter { $0.filterCategory == .fleetCapabilities }
        return ItemsFilterView(
            category: .fleetCapabilities,
            selectableFilters: QuoteListFilters.FleetCapabilities.allCases,
            selectedFilters: selectedFilters
        )
    }

    private func buildQuoteTypesFilterView() -> UIView {
        let selectedFilters = filters.filter { $0.filterCategory == .quoteTypes }
        return FilterListView(
            category: .quoteTypes,
            selectableFilters: QuoteListFilters.QuoteType.allCases,
            selectedFilters: selectedFilters
        )
    }
    
    private func buildServiceAgreementsFilterView() -> UIView {
        let selectedFilters = filters.filter { $0.filterCategory == .serviceAgreements }
        return FilterListView(
            category: .serviceAgreements,
            selectableFilters: QuoteListFilters.ServiceAgreements.allCases,
            selectedFilters: selectedFilters
        )
    }
}
