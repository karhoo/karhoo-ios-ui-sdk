//
//  BookingScreenBuilder.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import CoreLocation
import Foundation
import KarhooSDK

public protocol BookingScreenBuilder {
    func buildBookingScreen(
        journeyInfo: JourneyInfo?,
        passengerDetails: PassengerDetails?,
        callback: ScreenResultCallback<BookingScreenResult>?
    ) -> Screen
}

public extension BookingScreenBuilder {
    func buildBookingScreen(
        journeyInfo: JourneyInfo? = nil,
        passengerDetails: PassengerDetails? = nil,
        callback: ScreenResultCallback<BookingScreenResult>?
    ) -> Screen {
        buildBookingScreen(journeyInfo: journeyInfo, passengerDetails: passengerDetails, callback: callback)
    }
}

public protocol BookingScreenComponents {
    func addressBar(journeyInfo: JourneyInfo?) -> AddressBarView
    func mapView(
        journeyInfo: JourneyInfo?,
        onLocationPermissionDenied: (() -> Void)?
    ) -> MapView
}
