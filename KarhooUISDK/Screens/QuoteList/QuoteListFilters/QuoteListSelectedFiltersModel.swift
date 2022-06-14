//
//  QuoteListSelectedFiltersModel.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 13/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

struct QuoteListSelectedFiltersModel {
    var numberOfLuggages: Int
    var numberOfPassengers: Int
    var vehicleTypes: Set<QuoteListFilters.VehicleType>
    var vehicleClasses: Set<QuoteListFilters.VehicleClass>
    var vehicleExtras: Set<QuoteListFilters.VehicleExtras>
    var ecoFriendly: Set<QuoteListFilters.EcoFriendly>
    var fleetCapabilities: Set<QuoteListFilters.FleetCapabilities>
    var quoteType: Set<QuoteListFilters.QuoteType>
    var cancelationAndWaitingTime: Set<QuoteListFilters.CancelationAndWatingTime>

    init(
        numberOfLuggages: Int,
        numberOfPassengers: Int,
        vehicleTypes: Set<QuoteListFilters.VehicleType>,
        vehicleClasses: Set<QuoteListFilters.VehicleClass>,
        vehicleExtras: Set<QuoteListFilters.VehicleExtras>,
        ecoFriendly: Set<QuoteListFilters.EcoFriendly>,
        fleetCapabilities: Set<QuoteListFilters.FleetCapabilities>,
        quoteType: Set<QuoteListFilters.QuoteType>,
        cancelationAndWaitingTime: Set<QuoteListFilters.CancelationAndWatingTime>
    ) {
        self.numberOfLuggages = numberOfLuggages
        self.numberOfPassengers = numberOfPassengers
        self.vehicleTypes = vehicleTypes
        self.vehicleClasses = vehicleClasses
        self.vehicleExtras = vehicleExtras
        self.ecoFriendly = ecoFriendly
        self.fleetCapabilities = fleetCapabilities
        self.quoteType = quoteType
        self.cancelationAndWaitingTime = cancelationAndWaitingTime
    }

    static var `default`: QuoteListSelectedFiltersModel {
        QuoteListSelectedFiltersModel(
            numberOfLuggages: 0,
            numberOfPassengers: 1,
            vehicleTypes: [],
            vehicleClasses: [],
            vehicleExtras: [],
            ecoFriendly: [],
            fleetCapabilities: [],
            quoteType: [],
            cancelationAndWaitingTime: []
        )
    }
}
