//
//  FleetCapabilitiesFilter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 16/06/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit

extension QuoteListFilters {
    enum FleetCapabilities: String, QuoteListFilter, CaseIterable {
        case flightTracking = "flight_tracking"
        case trainTracking = "train_tracking"
        case gpsTracking = "gps_tracking"
        case driverDetails = "driver_details"
        case vehicleDetails = "vehicle_details"
        
        var filterCategory: QuoteListFilters.Category { .fleetCapabilities }

        var icon: UIImage? {
            switch self {
            case .gpsTracking:
                return .uisdkImage("kh_location-arrow-alt")
            case .flightTracking:
                return .uisdkImage("kh_plane")
            case .trainTracking:
                return .uisdkImage("kh_metro")
            case .driverDetails:
                return .uisdkImage("kh_user")
            case .vehicleDetails:
                return .uisdkImage("kh_car")
            }
        }

        var localizedString: String {
            switch self {
            case .gpsTracking:
                return UITexts.FleetCapabilities.gpsTracking
            case .flightTracking:
                return UITexts.FleetCapabilities.flightTracking
            case .trainTracking:
                return UITexts.FleetCapabilities.trainTracking
            case .driverDetails:
                return UITexts.FleetCapabilities.driverDetails
            case .vehicleDetails:
                return UITexts.FleetCapabilities.vehicleDetails
            }
        }

        func conditionMet(for quote: Quote) -> Bool {
            return quote.fleet.capability
                .map { $0.lowercased() }
                .contains(rawValue)
        }
    }
}

