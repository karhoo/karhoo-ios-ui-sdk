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

public protocol BookingScreenComponents {
    func addressBar(journeyInfo: JourneyInfo?) -> AddressBarView
}
