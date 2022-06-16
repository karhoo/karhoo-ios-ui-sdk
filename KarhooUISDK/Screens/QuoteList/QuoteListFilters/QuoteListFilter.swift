//
//  QuoteListFilter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 09/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

protocol QuoteListFilter {
    var icon: UIImage? { get }
    var filterCategory: QuoteListFilters.Category { get }
    func conditionMet(for quote: Quote) -> Bool
}

extension QuoteListFilter {
    var localizedString: String { filterCategory.localized }
    var selectionType: QuoteListFilters.SelectionType { filterCategory.selectionType }
    var icon: UIImage? { nil }
}

enum QuoteListFilters {
}

extension QuoteListFilters {

    enum Category: String {
        case luggage
        case passengers
        case vehicleType
        case vehicleClass
        case vehicleExtras
        case ecoFriendly
        case fleetCapabilities
        case quoteTypes
        case serviceAgreements
        
        var localized: String {
            switch self {
            case .luggage: return "luggage".localized
            case .passengers: return "passengers".localized
            case .vehicleType: return "vehicleType".localized
            case .vehicleClass: return "vehicleClass".localized
            case .vehicleExtras: return "vehicleExtras".localized
            case .ecoFriendly: return "ecoFriendly".localized
            case .fleetCapabilities: return "fleetCapabilities".localized
            case .quoteTypes: return "quoteTypes".localized
            case .serviceAgreements: return "cancelationAndWatingTime".localized
            }
        }
        
        var selectionType: SelectionType {
            switch self {
            case .luggage: return .number
            case .passengers: return .number
            case .vehicleType: return .multi
            case .vehicleClass: return .multi
            case .vehicleExtras: return .multi
            case .ecoFriendly: return .multi
            case .fleetCapabilities: return .multi
            case .serviceAgreements: return .multi
            case .quoteTypes: return .multi
            }
        }
    }

    enum SelectionType: String {
        case number
        case single
        case multi
    }

    struct LuggageCapasityModel: QuoteListFilter {
        var value: Int
        var minValue: Int { 0 }
        var maxValue: Int { 7 }
        var filterCategory: Category { .luggage }

        func conditionMet(for quote: Quote) -> Bool {
            quote.vehicle.luggageCapacity >= value
        }
    }

    struct PassengerCapacityModel: QuoteListFilter {
        var value: Int
        var minValue: Int { 1 }
        var maxValue: Int { 7 }
        var filterCategory: Category { .passengers }

        func conditionMet(for quote: Quote) -> Bool {
            quote.vehicle.passengerCapacity >= value
        }
    }

    enum VehicleType: String, QuoteListFilter {
        case all
        case standard
        case bus
        case mvp
        case moto

        var filterCategory: Category { .vehicleType }

        func conditionMet(for quote: Quote) -> Bool {
            if self == .all { return true }
            return quote.vehicle.type.lowercased() == rawValue
        }
    }

    enum VehicleClass: String, UserSelectable, CaseIterable, QuoteListFilter {
        case executive
        case luxury

        var filterCategory: Category { .vehicleClass }

        func conditionMet(for quote: Quote) -> Bool {
            quote.vehicle.vehicleClass.lowercased() == rawValue
        }
    }

    enum VehicleExtras: String, UserSelectable, CaseIterable, QuoteListFilter {
        case taxi
        case childSeat = "child-seat"
        case wheelchair

        var filterCategory: Category { .vehicleExtras }

        func conditionMet(for quote: Quote) -> Bool {
            quote.vehicle.tags
                .map { $0.lowercased() }
                .contains(rawValue)
        }
    }

    enum EcoFriendly: String, QuoteListFilter {
        case electric
        case hybrid

        var filterCategory: Category { .ecoFriendly }

        func conditionMet(for quote: Quote) -> Bool {
            quote.vehicle.tags
                .map { $0.lowercased() }
                .contains(rawValue)
        }
    }
    
    enum FleetCapabilities: String, QuoteListFilter {
        case flightTracking
        case trainTracking
        case gpsTracking
        case driverDetails
        case vehicleDetails
        
        var filterCategory: QuoteListFilters.Category { .fleetCapabilities }

        func conditionMet(for quote: Quote) -> Bool {
            return quote.fleet.capability
                .map { $0.lowercased() }
                .contains(rawValue)
        }
    }

    enum QuoteType: String, UserSelectable, CaseIterable, QuoteListFilter {
        case fixed
        case metered

        var filterCategory: Category { .quoteTypes}

        func conditionMet(for quote: Quote) -> Bool {
            quote.quoteType.rawValue.lowercased() == rawValue
        }
    }

    enum ServiceAgreements: String, QuoteListFilter {
        case freeCancelation = "free_cancellation"
        case freeWatingTime = "free_waiting_time"
        
        var filterCategory: QuoteListFilters.Category { .serviceAgreements }

        func conditionMet(for quote: Quote) -> Bool {
            switch self {
            case .freeCancelation:
                return quote.serviceLevelAgreements?.serviceCancellation.type != .other(value: nil)
            case .freeWatingTime:
                return (quote.serviceLevelAgreements?.serviceWaiting.minutes ?? 0) > 0
            }
        }
    }
}
