//
//  RidesListScreenBuilder.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import CoreLocation

public protocol RidesListScreenBuilder {
    func buildRidesListScreen(sortOrder: ComparisonResult,
                              tripsProvider: KarhooTripsProvider,
                              paginationEnabled: Bool) -> Screen
}
