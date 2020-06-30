//
//  TestDriverTrackingService.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

@testable import KarhooUISDK

class MockDriverTrackingService: DriverTrackingService {

    let trackDriverCall = MockPollCall<DriverTrackingInfo>()
    var trackDriverCalled = false
    func trackDriver(tripId: String) -> PollCall<DriverTrackingInfo> {
        trackDriverCalled = true
        return trackDriverCall
    }
}
