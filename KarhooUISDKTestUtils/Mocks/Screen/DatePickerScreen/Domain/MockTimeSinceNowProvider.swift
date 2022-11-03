//
//  MockTimeSinceNowProvider.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

final class MockTimeSinceNowProvider: DateTimeIntervalHelper {

    var intervalToReturn: TimeInterval!
    func intervalSinceNow(forDate date: Date) -> TimeInterval {
        return intervalToReturn
    }
}
