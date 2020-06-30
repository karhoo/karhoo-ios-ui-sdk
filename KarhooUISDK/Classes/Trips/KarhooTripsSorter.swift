//
//  TripsListSorter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import KarhooSDK

public protocol TripsSorter {
    func sort(trips: [TripInfo]) -> [TripInfo]
}

public final class KarhooTripsSorter: TripsSorter {

    private let sortOrder: ComparisonResult

    public init(sortOrder: ComparisonResult) {
        self.sortOrder = sortOrder
    }

    public func sort(trips: [TripInfo]) -> [TripInfo] {
        return trips.sorted(by: {
            ($0.dateScheduled ?? Date()).compare(
                $1.dateScheduled ?? Date()) == sortOrder
        })
    }
}
