//
//  MockTripsSorter.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
@testable import KarhooUISDK

final public class MockTripsSorter: TripsSorter {
    public init() {}

    public var sortedOrder: ComparisonResult?
    public var tripsOutput: [TripInfo]?
    public var sortCalled = false
    public func sort(trips: [TripInfo]) -> [TripInfo] {
        sortCalled = true
        return tripsOutput ?? trips
    }
}
