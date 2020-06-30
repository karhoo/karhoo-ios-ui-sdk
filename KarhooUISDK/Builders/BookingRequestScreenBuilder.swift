//
//  BookingRequestScreenBuilder.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

internal protocol BookingRequestScreenBuilder {

    func buildBookingRequestScreen(quote: Quote,
                                   bookingDetails: BookingDetails,
                                   callback: @escaping ScreenResultCallback<TripInfo>) -> Screen
}
