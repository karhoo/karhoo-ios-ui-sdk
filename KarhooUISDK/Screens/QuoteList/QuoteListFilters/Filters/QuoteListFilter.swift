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
    var localizedString: String { get }
    func conditionMet(for quote: Quote) -> Bool
}

extension QuoteListFilter {
    var selectionType: QuoteListFilters.SelectionType { filterCategory.selectionType }
    var icon: UIImage? { nil }
}

protocol QuoteListNumericFilter: QuoteListFilter {
    var value: Int { get set }
    var minValue: Int { get }
    var maxValue: Int { get }
    var defaultValue: Int { get }
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
            case .luggage: return UITexts.Quotes.filtersLuggages
            case .passengers: return UITexts.Quotes.filtersPassengers
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
}
