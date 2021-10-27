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

final class MockCheckoutScreenBuilder: CheckoutScreenBuilder {

    var quote: Quote?
    var callback: ScreenResultCallback<TripInfo>?
    let screenInstance = Screen()

    func buildCheckoutScreen(quote: Quote,
                             bookingDetails: BookingDetails,
                             bookingMetadata: [String: Any]?,
                             callback: @escaping ScreenResultCallback<TripInfo>) -> Screen {
        self.quote = quote
        self.callback = callback
        return screenInstance
    }

    func triggerCheckoutScreenResult(_ result: ScreenResult<TripInfo>) {
        callback?(result)
    }
}
