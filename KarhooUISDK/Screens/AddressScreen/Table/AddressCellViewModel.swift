//
//  AddressCellViewModel.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

struct AddressCellViewModel {
    
    let displayAddress: String
    let subtitleAddress: String
    let iconImageName: String
    let placeId: String
    
    init(address: Address) {
        self.displayAddress = address.displayAddress
        self.subtitleAddress = address.lineOne
        self.placeId = address.placeId
        self.iconImageName = AddressCellViewModel.asset(address.poiDetailsType)
    }
    
    init(place: Place) {
        self.displayAddress = place.displayAddress
        self.placeId = place.placeId
        self.subtitleAddress = ""
        self.iconImageName = AddressCellViewModel.asset(place.poiDetailsType)
    }
    
    private static func asset(_ detailsType: PoiDetailsType) -> String {
        return detailsType == .airport ? "airplane" : "search_result"
    }
}
