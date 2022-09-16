//
//  KarhooAddressMapPresenter.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

final class KarhooAddressMapPresenter: AddressMapPresenter {

    private let view: AddressMapView
    private let mapStrategy: PickupOnlyStrategyProtocol
    private var locationFromMap: LocationInfo?

    init(view: AddressMapView,
         mapStrategy: PickupOnlyStrategyProtocol = PickupOnlyStrategy()) {
        self.view = view
        self.mapStrategy = mapStrategy
        mapStrategy.load(
            map: view.mapView(),
            reverseGeolocate: true,
            onLocationPermissionDenied: nil
        )
        mapStrategy.set(delegate: self)

        mapStrategy.focusMap()
    }

    func lastSelectedLocation() -> LocationInfo? {
        return locationFromMap
    }

    func locatePressed() {
        focusMap()
    }
}

extension KarhooAddressMapPresenter: PickupOnlyStrategyDelegate {

    func setFromMap(pickup: LocationInfo?) {
        guard let location = pickup else {
            return
        }

        locationFromMap = location
        view.set(addressBarText: location.address.displayAddress)
    }

    func pickupFailedToSetFromMap(error: KarhooError?) {}
}
