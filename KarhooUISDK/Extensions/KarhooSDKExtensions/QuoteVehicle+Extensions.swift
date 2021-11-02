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
    
    var localizedVehicleClass: String {
        get {
            let value = vehicleClass.uppercased()
            
            guard let enumCase = VehicleClass(rawValue: value)
            else {
                return vehicleClass
            }
            
            return enumCase.title
        }
    }
    
    var localizedCarType: String {
        get {
            let value = type.uppercased()
            
            guard let enumCase = VehicleType(rawValue: value)
            else {
                return type
            }
            
            return enumCase.title
        }
    }
}

public enum VehicleClass: String {
    case saloon = "SALOON"
    case taxi = "TAXI"
    case mpv = "MPV"
    case exec = "EXEC"
    case moto = "MOTO"
    case motorcycle = "MOTORCYCLE"
    case electric = "ELECTRIC"
    
    var title: String {
        switch self {
        case .saloon:
            return UITexts.VehicleClass.saloon
        case .taxi:
            return UITexts.VehicleClass.taxi
        case .mpv:
            return UITexts.VehicleClass.mpv
        case .exec:
            return UITexts.VehicleClass.exec
        case .moto:
            return UITexts.VehicleClass.moto
        case .motorcycle:
            return UITexts.VehicleClass.motorcycle
        case .electric:
            return UITexts.VehicleClass.electric
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

