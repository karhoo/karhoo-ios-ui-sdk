//
//  MockCheckoutScreenBuilder.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

@testable import KarhooUISDK

final public class MockCheckoutScreenBuilder: CheckoutScreenBuilder {

    public var quote: Quote?
    public var callback: ScreenResultCallback<TripInfo>?
    public let screenInstance = Screen()

    public func buildCheckoutScreen(quote: Quote,
                             journeyDetails: JourneyDetails,
                             bookingMetadata: [String: Any]?,
                             callback: @escaping ScreenResultCallback<TripInfo>) -> Screen {
        self.quote = quote
        self.callback = callback
        return screenInstance
    }

    public func triggerCheckoutScreenResult(_ result: ScreenResult<TripInfo>) {
        callback?(result)
    }
}
