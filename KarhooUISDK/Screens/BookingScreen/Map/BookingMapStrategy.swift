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
    case background = "pin_background_icon"
    case pickup = "pin_pickUp_icon"
    case destination = "pin_destination_icon"
    case driverLocation = "car_icon"
}

protocol BookingMapStrategy: AnyObject {
    func load(map: MapView?, reverseGeolocate: Bool)
    func start(bookingDetails: BookingDetails?)
    func focusMap()
    func changed(bookingDetails: BookingDetails?)
    func stop()
}
