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
    func buildBookingScreen(journeyInfo: JourneyInfo?,
                            passengerDetails: PassengerDetails?,
                            loyaltyInfo: LoyaltyInfo?,
                            callback: ScreenResultCallback<BookingScreenResult>?) -> Screen
}

public extension BookingScreenBuilder {
    func buildBookingScreen(journeyInfo: JourneyInfo? = nil,
                            passengerDetails: PassengerDetails? = nil,
                            loyaltyInfo: LoyaltyInfo? = nil,
                            callback: ScreenResultCallback<BookingScreenResult>?) -> Screen {
        
        return buildBookingScreen(journeyInfo: journeyInfo, passengerDetails: passengerDetails, loyaltyInfo: loyaltyInfo, callback: callback)
    }
}

public protocol BookingScreenComponents {
    func addressBar(journeyInfo: JourneyInfo?) -> AddressBarView
}
