//
//  RidesListScreenBuilder.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import CoreLocation
import Foundation
import KarhooSDK

public protocol RidesListScreenBuilder {
    func buildRidesListScreen(sortOrder: ComparisonResult,
                              tripsProvider: KarhooTripsProvider,
                              paginationEnabled: Bool) -> Screen
}
