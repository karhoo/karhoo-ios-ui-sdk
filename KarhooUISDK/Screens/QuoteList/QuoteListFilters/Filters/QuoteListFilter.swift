//
//  QuoteListFilter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 09/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit

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

extension QuoteListNumericFilter {
    var isInDefaultState: Bool { value == defaultValue}
}

public enum QuoteListFilters {
    static let defaultPassengersCount = 1
    static let defaultLuggagesCount = 0
}

extension QuoteListFilters {
    public enum Category: String {
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
            case .luggage:
                return UITexts.Quotes.filtersLuggages
            case .passengers:
                return UITexts.Quotes.filtersPassengers
            case .vehicleType:
                return UITexts.QuoteFilterCategory.vehicleType
            case .vehicleClass:
                return UITexts.QuoteFilterCategory.vehicleClass
            case .vehicleExtras:
                return UITexts.QuoteFilterCategory.vehicleExtras
            case .ecoFriendly:
                return UITexts.QuoteFilterCategory.ecoFriendly
            case .fleetCapabilities:
                return UITexts.QuoteFilterCategory.fleetCapabilities
            case .quoteTypes:
                return UITexts.QuoteFilterCategory.quoteTypes
            case .serviceAgreements:
                return UITexts.QuoteFilterCategory.serviceAgreements
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
        
        static let all: [QuoteListFilters.Category] = [.passengers, .luggage, .vehicleType, .vehicleClass, .vehicleExtras, .ecoFriendly, .fleetCapabilities, .quoteTypes, .serviceAgreements]
        
        static var sortedAll: [QuoteListFilters.Category] {
            all.sorted(by: { $0.sortOrder < $1.sortOrder })
        }
        
        var sortOrder: Int {
            switch self {
            case .luggage: return 2
            case .passengers: return 1
            case .vehicleType: return 3
            case .vehicleClass: return 4
            case .vehicleExtras: return 5
            case .ecoFriendly: return 6
            case .fleetCapabilities: return 7
            case .serviceAgreements: return 9
            case .quoteTypes: return 8
            }
        }
    }

    enum SelectionType: String {
        case number
        case single
        case multi
    }
}
