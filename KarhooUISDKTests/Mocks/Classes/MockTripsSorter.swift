//
//  MockTripsSorter.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK
@testable import KarhooUISDK

final class MockTripsSorter: TripsSorter {

    var sortedOrder: ComparisonResult?
    var tripsOutput: [TripInfo]?
    var sortCalled = false
    func sort(trips: [TripInfo]) -> [TripInfo] {
        sortCalled = true
        return tripsOutput ?? trips
    }
}
