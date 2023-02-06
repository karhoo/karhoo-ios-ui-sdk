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
        navigationController: UINavigationController?,
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]?,
        callback: @escaping ScreenResultCallback<KarhooCheckoutResult>
    ) -> KarhooUISDKSceneCoordinator
}

public extension CheckoutScreenBuilder {
    func buildCheckoutScreen(
        navigationController: UINavigationController?,
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]? = nil,
        callback: @escaping ScreenResultCallback<KarhooCheckoutResult>
    ) -> KarhooUISDKSceneCoordinator {
        buildCheckoutScreen(
            navigationController: navigationController,
            quote: quote,
            journeyDetails: journeyDetails,
            bookingMetadata: bookingMetadata,
            callback: callback
        )
    }
}
