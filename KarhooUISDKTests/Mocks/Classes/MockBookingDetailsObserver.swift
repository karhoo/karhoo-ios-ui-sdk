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
    var lastBookingState: JourneyDetails?
    var bookingStateChangedCalled = false

    func bookingStateChanged(details: JourneyDetails?) {
        lastBookingState = details
        bookingStateChangedCalled = true
    }
}
