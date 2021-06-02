//
//  BookingRequestScreenBuilder.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

public protocol BookingRequestScreenBuilder {

    func buildBookingRequestScreen(quote: Quote,
                                   bookingDetails: BookingDetails,
                                   bookingMeta: [String: Any],
                                   callback: @escaping ScreenResultCallback<TripInfo>) -> Screen
}
