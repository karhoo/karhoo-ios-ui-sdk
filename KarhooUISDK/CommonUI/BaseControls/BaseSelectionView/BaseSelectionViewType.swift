//
//  BaseSelectionViewType.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public enum BaseSelectionViewType {
    case mapPickUp
    case mapDropOff
    case currentLocation
    case none
    
    var iconName: String {
        switch self {
        case .mapPickUp:
            return "kh_uisdk_pin_pickup_icon"
        case .mapDropOff:
            return "kh_uisdk_pin_destination_icon"
        case .currentLocation:
            return "kh_uisdk_current_location_icon"
        case .none:
            return ""
        }
    }
    
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
