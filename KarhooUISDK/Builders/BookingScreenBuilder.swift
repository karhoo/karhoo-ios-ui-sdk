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
    func buildBookingScreen(journeyInfo: TripLocationInfo?,
                            passengerDetails: PassengerDetails?,
                            callback: ScreenResultCallback<BookingScreenResult>?) -> Screen
}

public extension BookingScreenBuilder {
    func buildBookingScreen(journeyInfo: TripLocationInfo? = nil,
                            passengerDetails: PassengerDetails? = nil,
                            callback: ScreenResultCallback<BookingScreenResult>? = nil) -> Screen {
        return buildBookingScreen(journeyInfo: journeyInfo,
                                  passengerDetails: passengerDetails,
                                  callback: callback)
    }
}

public protocol BookingScreenComponents {
    func addressBar(journeyInfo: TripLocationInfo?) -> AddressBarView
}
