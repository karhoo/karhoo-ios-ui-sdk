//
//  MockTimeSinceNowProvider.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

final public class MockTimeSinceNowProvider: DateTimeIntervalHelper {

    public var intervalToReturn: TimeInterval!
    public func intervalSinceNow(forDate date: Date) -> TimeInterval {
        return intervalToReturn
    }
}
