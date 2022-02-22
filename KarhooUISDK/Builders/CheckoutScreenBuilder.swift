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
    func buildCheckoutScreen(
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]?,
        callback: @escaping ScreenResultCallback<TripInfo>
    ) -> Screen
}

public extension CheckoutScreenBuilder {
    func buildCheckoutScreen(
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]? = nil,
        callback: @escaping ScreenResultCallback<TripInfo>
    ) -> Screen {
        
        return buildCheckoutScreen(
            quote: quote,
            journeyDetails: journeyDetails,
            bookingMetadata: bookingMetadata,
            callback: callback
        )
    }
}
