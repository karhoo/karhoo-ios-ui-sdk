//
//  BaseSelectionViewType.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public enum BaseSelectionViewType: String {
    case mapPickUp = "pickup_pin"
    case mapDropOff = "dropoff_pin"
    case currentLocation = "current_location_icon"
    case none = ""
    
    var titleText: String {
        switch self {
        case .mapPickUp, .mapDropOff:
            return UITexts.AddressScreen.setOnMap
        case .currentLocation:
            return UITexts.AddressScreen.currentLocation
        default:
            return ""
        }
    }
}
