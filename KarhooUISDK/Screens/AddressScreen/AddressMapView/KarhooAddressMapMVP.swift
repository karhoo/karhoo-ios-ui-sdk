//
//  KarhooAddressMapMVP.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

protocol AddressMapView: AnyObject {
    func set(actions: AddressMapActions, addressType: AddressType)
    func mapView() -> MapView
    func set(addressBarText: String)
}

protocol AddressMapActions: AnyObject {
    func addressMapSelected(location: LocationInfo)
    func closeAddressMapView()
}
