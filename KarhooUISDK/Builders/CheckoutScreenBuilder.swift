//
//  CheckoutScreenBuilder.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

public protocol CheckoutScreenBuilder {

    func buildCheckoutScreen(quote: Quote,
                             bookingDetails: BookingDetails,
                             bookingMetadata: [String: Any]?,
                             callback: @escaping ScreenResultCallback<TripInfo>) -> Screen
}
