//
//  MockDriverTrackingService.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

@testable import KarhooUISDK

public class MockDriverTrackingService: DriverTrackingService {
    public init() {}

    public let trackDriverCall = MockPollCall<DriverTrackingInfo>()
    public var trackDriverCalled = false
    public func trackDriver(tripId: String) -> PollCall<DriverTrackingInfo> {
        trackDriverCalled = true
        return trackDriverCall
    }
}
