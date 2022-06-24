//
//  FleetCapabilitiesFilter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 16/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

extension QuoteListFilters {
    enum FleetCapabilities: String, QuoteListFilter, CaseIterable {
        case flightTracking
        case trainTracking
        case gpsTracking
        case driverDetails
        case vehicleDetails
        
        var filterCategory: QuoteListFilters.Category { .fleetCapabilities }
        
        var localizedString: String {
            rawValue
        }

        func conditionMet(for quote: Quote) -> Bool {
            return quote.fleet.capability
                .map { $0.lowercased() }
                .contains(rawValue)
        }
    }
}

