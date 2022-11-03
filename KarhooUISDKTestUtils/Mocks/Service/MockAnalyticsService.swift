//
//  MockAnalyticsService.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

public class MockAnalyticsService: AnalyticsService {
    
    public var eventSent: AnalyticsConstants.EventNames?
    public var eventPayloadSent: [String: Any]?

    public func send(eventName: AnalyticsConstants.EventNames, payload: [String: Any]) {
        eventSent = eventName
        eventPayloadSent = payload
    }

    public func send(eventName: AnalyticsConstants.EventNames) {
        eventSent = eventName
    }
}
