//
//  MockTimeFetcher.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooUISDK

final class MockTimeFetcher: TimeFetcher {
    var timeToDeliver: Date = Date()
    func now() -> Date {
        return timeToDeliver
    }
}
