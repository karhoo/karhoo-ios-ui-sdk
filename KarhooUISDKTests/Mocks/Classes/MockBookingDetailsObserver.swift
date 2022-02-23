//
//  MockBookingDetailsObserver.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooUISDK

final class MockBookingDetailsObserver: JourneyDetailsObserver {
    var lastBookingState: JourneyDetails?
    var bookingStateChangedCalled = false

    func journeyDetailsChanged(details: JourneyDetails?) {
        lastBookingState = details
        bookingStateChangedCalled = true
    }
}
