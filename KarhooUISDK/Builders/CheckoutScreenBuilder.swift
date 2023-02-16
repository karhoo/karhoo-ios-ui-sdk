//
//  CheckoutScreenBuilder.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import UIKit
import KarhooSDK

public protocol CheckoutScreenBuilder {
    func buildCheckoutCoordinator(
        navigationController: UINavigationController?,
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]?,
        callback: @escaping ScreenResultCallback<KarhooCheckoutResult>
    ) -> KarhooUISDKSceneCoordinator
}

public extension CheckoutScreenBuilder {
    func buildCheckoutCoordinator(
        quote: Quote,
        journeyDetails: JourneyDetails,
        callback: @escaping ScreenResultCallback<KarhooCheckoutResult>
    ) -> KarhooUISDKSceneCoordinator {
        buildCheckoutCoordinator(
            navigationController: nil,
            quote: quote,
            journeyDetails: journeyDetails,
            bookingMetadata: nil,
            callback: callback
        )
    }
}
