//
//  TimeSinceNowProvider.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

// this is for mocking timeSinceNow without swizzling / overriding Date

protocol DateTimeIntervalHelper {
    func intervalSinceNow(forDate date: Date) -> TimeInterval
}

final class TimeSinceNowProvider: DateTimeIntervalHelper {

    func intervalSinceNow(forDate date: Date) -> TimeInterval {
        return date.timeIntervalSinceNow
    }
}
