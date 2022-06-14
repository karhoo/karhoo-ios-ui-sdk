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
    var filterValue: String { get }
    var icon: UIImage? { get }
    var filterCategory: QuoteListFilters.Category { get }
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
        case cancelationAndWatingTime
        
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
            case .cancelationAndWatingTime: return "cancelationAndWatingTime".localized
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
            case .cancelationAndWatingTime: return .multi
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
        var filterValue: String { value.description }
    }

    struct PassengersCapasityModel: QuoteListFilter {
        var value: Int
        var minValue: Int { 1 }
        var maxValue: Int { 7 }
        var filterCategory: Category { .passengers }
        var filterValue: String { value.description }
    }

    enum VehicleType: String, QuoteListFilter {
        case standard
        case berline
        case van
        case moto
        case bike

        var filterCategory: Category { .vehicleType }
        var filterValue: String { rawValue.description }
    }

    enum VehicleClass: String, UserSelectable, CaseIterable, QuoteListFilter {
        case executive
        case luxury

        var filterCategory: Category { .vehicleClass }
        var filterValue: String { rawValue }
    }

    enum VehicleExtras: String, UserSelectable, CaseIterable, QuoteListFilter {
        case taxi
        case childSeat
        case wheelchair

        var filterCategory: Category { .vehicleExtras }
        var filterValue: String { rawValue }
    }

    enum EcoFriendly: String, QuoteListFilter {
        case electric
        case hybrid

        var filterCategory: Category { .ecoFriendly }
        var filterValue: String { rawValue.description }
    }
    
    enum FleetCapabilities: String, QuoteListFilter {
        case flightTracking
        case trainTracking
        case gpsTracking
        case driverDetails
        case vehicleDetails
        
        var filterCategory: QuoteListFilters.Category { .fleetCapabilities }
        var filterValue: String { rawValue }
    }

    enum QuoteType: String, UserSelectable, CaseIterable, QuoteListFilter {
        case fixedPrice
        case meteredPrice

        var filterCategory: Category { .quoteTypes}
        var filterValue: String { rawValue }
    }

    enum CancelationAndWatingTime: String, QuoteListFilter {
        case freeCancelation
        case freeWatingTime
        
        var filterCategory: QuoteListFilters.Category { .cancelationAndWatingTime }
        var filterValue: String { rawValue }
    }
}
