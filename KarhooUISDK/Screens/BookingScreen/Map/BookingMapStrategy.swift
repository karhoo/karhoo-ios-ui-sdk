//
//  BookingMapStrategy.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import CoreLocation
import KarhooSDK

enum PinAsset: String {
    case background = "kh_pin_background_icon"
    case pickup = "kh_pin_pickup_icon"
    case destination = "kh_pin_destination_icon"
    case driverLocation = "kh_car_icon"
}

protocol BookingMapStrategy: AnyObject {
    func load(
        map: MapView?,
        reverseGeolocate: Bool,
        onLocationPermissionDenied: (() -> Void)?
    )
    func start(journeyDetails: JourneyDetails?)
    func focusMap()
    func changed(journeyDetails: JourneyDetails?)
    func stop()
}
