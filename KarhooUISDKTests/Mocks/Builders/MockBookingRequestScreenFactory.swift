//
//  MockBookingRequestScreenFactory.swift
//  KarhooTests
//
//  Created by Vojtech Vrbka on 28/12/2018.
//  Copyright © 2018 Flit Technologies LTD. All rights reserved.
//

import Foundation
import KarhooSDK

final class MockBookingRequestScreenBuilder: BookingRequestScreenBuilder {

    var bookingRequestQuote: Quote?
    var bookingRequestCallback: ScreenResultCallback<TripInfo>?
    let bookingRequestScreenInstance = Screen()

    func createBookingRequestScreen(quote: Quote,
                                    bookingDetails: BookingDetails,
                                    routing: BookingRequestViewRouting,
                                    callback: @escaping ScreenResultCallback<TripInfo>) -> Screen {
        bookingRequestQuote = quote
        bookingRequestCallback = callback
        return bookingRequestScreenInstance
    }
}
