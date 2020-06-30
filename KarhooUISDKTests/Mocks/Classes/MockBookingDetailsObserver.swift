//
//  MockBookingDetailsObserver.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooUISDK

final class MockBookingDetailsObserver: BookingDetailsObserver {
    var lastBookingState: BookingDetails?
    var bookingStateChangedCalled = false

    func bookingStateChanged(details: BookingDetails?) {
        lastBookingState = details
        bookingStateChangedCalled = true
    }
}
