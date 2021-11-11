//
//  MockRecentAddressProvider.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import CoreLocation
@testable import KarhooUISDK

final class MockRecentAddressProvider: RecentAddressProvider {
    
    let addressToReturn = Address(placeId: "place123",
                                  displayAddress: "display",
                                  lineOne: "line1")
    var addedRecent: Address?

    func getRecents() -> [LocationInfo] {
        return [addressToReturn]
    }
    func add(recent: LocationInfo) {
        addedRecent = recent
    }
}
