//
//  MockBookingRequestScreenFactory.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

@testable import KarhooUISDK

final class MockBookingRequestScreenBuilder: CheckoutScreenBuilder {

    var bookingRequestQuote: Quote?
    var bookingRequestCallback: ScreenResultCallback<TripInfo>?
    let bookingRequestScreenInstance = Screen()

    func buildCheckoutScreen(quote: Quote,
                                   bookingDetails: BookingDetails,
                                   bookingMetadata: [String: Any]?,
                                   callback: @escaping ScreenResultCallback<TripInfo>) -> Screen {
        bookingRequestQuote = quote
        bookingRequestCallback = callback
        return bookingRequestScreenInstance
    }

    func triggerBookingRequestScreenResult(_ result: ScreenResult<TripInfo>) {
        bookingRequestCallback?(result)
    }
}
