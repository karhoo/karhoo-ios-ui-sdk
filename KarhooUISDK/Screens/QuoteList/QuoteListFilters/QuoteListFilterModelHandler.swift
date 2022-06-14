//
//  QuoteListFilterModelHandler.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 13/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

class KarhooQuoteListFilterModelHandler {
    
    var model: QuoteListSelectedFiltersModel = .default
    
    func filterSelected(_ filter: QuoteListFilter) {
        switch filter.filterCategory {
        case .luggage: addLuggageFilter(filter)
        case .passengers: addPassengersFilter(filter)
        case .vehicleType: addVehicleTypeFilter(filter)
        case .vehicleClass: addVehicleClassFilter(filter)
        case .vehicleExtras: addVehicleExtrasFilter(filter)
        case .ecoFriendly: addEcoFriendlyFilter(filter)
        case .fleetCapabilities: addFleetCapabilityFilter(filter)
        case .quoteTypes: addQuoteTypeFilter(filter)
        case .cancelationAndWatingTime: addCancelationAndWatingTimeFilter(filter)
        }
    }

    func filterDeselected(_ filter: QuoteListFilter) {
        switch filter.filterCategory {
        case .luggage: removeLuggageFilter(filter)
        case .passengers: removePassengersFilter(filter)
        case .vehicleType: removeVehicleTypeFilter(filter)
        case .vehicleClass: removeVehicleClassFilter(filter)
        case .vehicleExtras: removeVehicleExtrasFilter(filter)
        case .ecoFriendly: removeEcoFriendlyFilter(filter)
        case .fleetCapabilities: removeFleetCapabilityFilter(filter)
        case .quoteTypes: removeQuoteTypeFilter(filter)
        case .cancelationAndWatingTime: removeCancelationAndWatingTimeFilter(filter)
        }
    }

    private func addLuggageFilter(_ filter: QuoteListFilter) {
        guard let filter = filter as? QuoteListFilters.LuggageCapasityModel
        else {
            assertionFailure()
            return
        }
        model.numberOfLuggages = filter.value
    }

    private func addPassengersFilter(_ filter: QuoteListFilter) {
        guard let filter = filter as? QuoteListFilters.PassengersCapasityModel
        else {
            assertionFailure()
            return
        }
        model.numberOfPassengers = filter.value
    }

    private func addVehicleTypeFilter(_ filter: QuoteListFilter) {
        guard let filter = filter as? QuoteListFilters.VehicleType
        else {
            assertionFailure()
            return
        }
        model.vehicleTypes.insert(filter)
    }

    private func addVehicleClassFilter(_ filter: QuoteListFilter) {
        guard let filter = filter as? QuoteListFilters.VehicleClass
        else {
            assertionFailure()
            return
        }
        model.vehicleClasses.insert(filter)
    }

    private func addVehicleExtrasFilter(_ filter: QuoteListFilter) {
        guard let filter = filter as? QuoteListFilters.VehicleExtras
        else {
            assertionFailure()
            return
        }
        model.vehicleExtras.insert(filter)
    }

    private func addEcoFriendlyFilter(_ filter: QuoteListFilter) {
        guard let filter = filter as? QuoteListFilters.EcoFriendly
        else {
            assertionFailure()
            return
        }
        model.ecoFriendly.insert(filter)
    }

    private func addFleetCapabilityFilter(_ filter: QuoteListFilter) {
        guard let filter = filter as? QuoteListFilters.FleetCapabilities
        else {
            assertionFailure()
            return
        }
        model.fleetCapabilities.insert(filter)
    }

    private func addQuoteTypeFilter(_ filter: QuoteListFilter) {
        guard let filter = filter as? QuoteListFilters.QuoteType
        else {
            assertionFailure()
            return
        }
        model.quoteType.insert(filter)
    }

    private func addCancelationAndWatingTimeFilter(_ filter: QuoteListFilter) {
        guard let filter = filter as? QuoteListFilters.CancelationAndWatingTime
        else {
            assertionFailure()
            return
        }
        model.cancelationAndWaitingTime.insert(filter)
    }

    private func removeLuggageFilter(_ filter: QuoteListFilter) {
        model.numberOfLuggages = QuoteListSelectedFiltersModel.default.numberOfLuggages
    }

    private func removePassengersFilter(_ filter: QuoteListFilter) {
        assertionFailure()
    }

    private func removeVehicleTypeFilter(_ filter: QuoteListFilter) {
        assertionFailure()
    }

    private func removeVehicleClassFilter(_ filter: QuoteListFilter) {
        assertionFailure()
    }

    private func removeVehicleExtrasFilter(_ filter: QuoteListFilter) {
        assertionFailure()
    }

    private func removeEcoFriendlyFilter(_ filter: QuoteListFilter) {
        assertionFailure()
    }

    private func removeFleetCapabilityFilter(_ filter: QuoteListFilter) {
        assertionFailure()
    }

    private func removeQuoteTypeFilter(_ filer: QuoteListFilter) {
        assertionFailure()
    }

    private func removeCancelationAndWatingTimeFilter(_ filter: QuoteListFilter) {
        assertionFailure()
    }
}
