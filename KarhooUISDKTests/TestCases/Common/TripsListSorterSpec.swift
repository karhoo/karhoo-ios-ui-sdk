//
//  TripsListSorterSpec.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import XCTest
import KarhooUISDK

class TripsListSorterSpec: XCTestCase {

    private var testObject: KarhooTripsSorter?

    // tripDateA  is closer to 1970 than tripDateB
    private let tripDateA = TestUtil.getRandomTrip(dateScheduled: Date(timeIntervalSince1970: 10))
    private let tripDateB = TestUtil.getRandomTrip(dateScheduled: Date(timeIntervalSince1970: 20))

    /**
      * When: The sorter is sorting in descending order
      * Then: It should return trips in a descending order
      */
    func testDescendingSort() {
        testObject = KarhooTripsSorter(sortOrder: .orderedDescending)

        let incorrectOrder = [tripDateA, tripDateB]
        let descendingOrder = testObject!.sort(trips: incorrectOrder)

        XCTAssertEqual(descendingOrder[0].tripId, tripDateB.tripId)
        XCTAssertEqual(descendingOrder[1].tripId, tripDateA.tripId)
    }

    /**
     * When: The sorter is sorting in ascending order
     * Then: It should return trips in a ascending order
     */
    func testAscendingSort() {
        testObject = KarhooTripsSorter(sortOrder: .orderedAscending)

        let incorrectOrder = [tripDateB, tripDateA]
        let ascendingOrder = testObject!.sort(trips: incorrectOrder)

        XCTAssertEqual(ascendingOrder[0].tripId, tripDateA.tripId)
        XCTAssertEqual(ascendingOrder[1].tripId, tripDateB.tripId)
    }
}
