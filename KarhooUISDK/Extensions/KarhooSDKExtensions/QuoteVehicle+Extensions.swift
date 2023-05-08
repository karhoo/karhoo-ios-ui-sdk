//
//  QuoteVehicle+Extensions.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 01.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

extension QuoteVehicle {
    var localizedVehicleType: String {
        let value = type.uppercased()
        
        guard let enumCase = VehicleType(rawValue: value)
        else {
            return type
        }
        
        return enumCase.title
    }
    
    func getVehicleImageTag(rule: VehicleImageRule?) -> String {
        let vehicleTags = tags.map({ $0.lowercased() })
        
        if vehicleTags.contains("economy") {
            return UITexts.Accessibility.vehicleLogoEconomy
        } else if vehicleTags.contains("electric") {
            return UITexts.Accessibility.vehicleLogoElectric
        } else if vehicleTags.contains("hybrid") {
            return UITexts.Accessibility.vehicleLogoHybrid
        } else {
            return rule?.tags.first ?? vehicleTags.first ?? getVehicleTypeText()
        }
    }
}

public enum VehicleType: String {
    case moto = "MOTO"
    case standard = "STANDARD"
    case mpv = "MPV"
    case bus = "BUS"
    
    var title: String {
        switch self {
        case .moto:
            return UITexts.VehicleType.moto
        case .standard:
            return UITexts.VehicleType.standard
        case .mpv:
            return UITexts.VehicleType.mpv
        case .bus:
            return UITexts.VehicleType.bus
        }
    }
}
