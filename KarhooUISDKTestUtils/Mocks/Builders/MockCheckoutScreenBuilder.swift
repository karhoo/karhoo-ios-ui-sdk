//
//  MockCheckoutScreenBuilder.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import UIKit
import KarhooSDK

@testable import KarhooUISDK

final public class MockCheckoutScreenBuilder: CheckoutScreenBuilder {
    public init() {}

    public var quote: Quote?
    public var callback: ScreenResultCallback<KarhooCheckoutResult>?
    public var screenInstance = MockCoordinator()

    public func buildCheckoutCoordinator(
        navigationController: UINavigationController?,
        quote: KarhooSDK.Quote,
        journeyDetails: KarhooUISDK.JourneyDetails,
        bookingMetadata: [String : Any]?,
        callback: @escaping KarhooUISDK.ScreenResultCallback<KarhooUISDK.KarhooCheckoutResult>
    ) -> KarhooUISDK.KarhooUISDKSceneCoordinator {
        self.quote = quote
        self.callback = callback
        return screenInstance
    }

    public func triggerCheckoutScreenResult(_ result: ScreenResult<KarhooCheckoutResult>) {
        callback?(result)
    }
}
