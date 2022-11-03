//
//  MockAnalyticsService.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

class MockAnalyticsService: AnalyticsService {
    
    private(set) var eventSent: AnalyticsConstants.EventNames?
    private(set) var eventPayloadSent: [String: Any]?

    func send(eventName: AnalyticsConstants.EventNames, payload: [String: Any]) {
        eventSent = eventName
        eventPayloadSent = payload
    }

    func send(eventName: AnalyticsConstants.EventNames) {
        eventSent = eventName
    }
}
