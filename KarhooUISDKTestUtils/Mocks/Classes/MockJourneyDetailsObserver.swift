//
//  MockBookingDetailsObserver.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooUISDK

final class MockJourneyDetailsObserver: JourneyDetailsObserver {
    var lastJourneyDetails: JourneyDetails?
    var journeyDetailsChangedCalled = false

    func journeyDetailsChanged(details: JourneyDetails?) {
        lastJourneyDetails = details
        journeyDetailsChangedCalled = true
    }
}
