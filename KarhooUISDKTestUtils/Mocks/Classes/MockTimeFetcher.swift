//
//  MockTimeFetcher.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooUISDK

final public class MockTimeFetcher: TimeFetcher {
    public var timeToDeliver: Date = Date()
    public func now() -> Date {
        return timeToDeliver
    }
}
