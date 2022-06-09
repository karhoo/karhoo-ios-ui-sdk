//
//  QuoteListFilter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 09/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

enum QuoteListFilterCategory: String {
    case luggage
    case passengers
    case vehicleType
    
    var localized: String {
        switch self {
        case .luggage: return "luggage".localized
        case .passengers: return "passengers".localized
        case .vehicleType: return "vehicleType".localized
        }
    }
    
   
}

enum QuoteListFilterSelectionType: String {
    case number
    case single
    case multi
}

enum QuoteListFilter {
    case luggage
    case passengers
    case vehicleTypes
    case vehicleClasses
    
    func meetsCriteria(quote: Quote) -> Bool {
        false
    }
    
    var selectionType: QuoteListFilterSelectionType {
        switch self {
        case .luggage: return .number
        case .passengers: return .single
        case .vehicleTypes: return .multi
        case .vehicleClasses: return .multi
        }
    }
}

enum QuoteListFilters {
}

extension QuoteListFilter {
    enum VehicleTypes: UserSelectable, CaseIterable {
        case standard
        case moto
        case bike
        case van

        var localizedString: String {
            "VehicleTypes"
        }
    }
 
    enum VehicleClasses: UserSelectable, CaseIterable {
        case standard
        case moto
        case bike
        case van

        var localizedString: String {
            "VehicleClasses"
        }
    }
}
