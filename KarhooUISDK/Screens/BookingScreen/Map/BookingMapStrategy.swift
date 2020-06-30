//
//  BookingMapStrategy.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import CoreLocation
import KarhooSDK

enum PinAsset {
    static let pickup = "pickup_pin"
    static let destination = "dropoff_pin"
}

protocol BookingMapStrategy: AnyObject {
    func load(map: MapView?)
    func start(bookingDetails: BookingDetails?)
    func focusMap()
    func changed(bookingDetails: BookingDetails?)
    func stop()
}
