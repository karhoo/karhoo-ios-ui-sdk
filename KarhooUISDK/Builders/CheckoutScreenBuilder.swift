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
                             loyaltyInfo: LoyaltyInfo?,
                             callback: @escaping ScreenResultCallback<TripInfo>) -> Screen
}

public extension CheckoutScreenBuilder {
    func buildCheckoutScreen(quote: Quote,
                             bookingDetails: BookingDetails,
                             bookingMetadata: [String: Any]? = nil,
                             loyaltyInfo: LoyaltyInfo? = nil,
                             callback: @escaping ScreenResultCallback<TripInfo>) -> Screen {
        
        return buildCheckoutScreen(quote: quote, bookingDetails: bookingDetails, bookingMetadata: bookingMetadata, loyaltyInfo: loyaltyInfo, callback: callback)
    }
}
