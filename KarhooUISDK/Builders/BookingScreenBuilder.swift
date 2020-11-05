//
//  BookingScreenBuilder.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import CoreLocation
import KarhooSDK

public protocol BookingScreenBuilder {
    func buildBookingScreen(tripInfo: TripLocationInfo?,
                            passengerDetails: PassengerDetails?,
                            callback: ScreenResultCallback<BookingScreenResult>?) -> Screen
}

public extension BookingScreenBuilder {
    func buildBookingScreen(tripInfo: TripLocationInfo? = nil,
                            passengerDetails: PassengerDetails? = nil,
                            callback: ScreenResultCallback<BookingScreenResult>? = nil) -> Screen {
        return buildBookingScreen(tripInfo: tripInfo,
                                  passengerDetails: passengerDetails,
                                  callback: callback)
    }
}

public protocol BookingScreenComponents {
    func addressBar(tripInfo: TripLocationInfo?) -> AddressBarView
}
