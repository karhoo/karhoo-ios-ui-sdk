//
//  TestDriverTrackingService.swift
//  KarhooTests
//
//  Created by Vojtech Vrbka on 13/07/2018.
//  Copyright © 2018 Flit Technologies LTD. All rights reserved.
//

import Foundation
import KarhooSDK

@testable import Karhoo

class MockDriverTrackingService: DriverTrackingService {

    let trackDriverCall = MockPollCall<DriverTrackingInfo>()
    var trackDriverCalled = false
    func trackDriver(tripId: String) -> PollCall<DriverTrackingInfo> {
        trackDriverCalled = true
        return trackDriverCall
    }
}
