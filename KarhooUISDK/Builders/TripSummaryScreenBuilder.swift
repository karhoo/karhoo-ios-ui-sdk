//
//  TripSummaryScreenFactory.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

internal protocol TripSummaryScreenBuilder {
    func buildTripSummaryScreen(trip: TripInfo,
                                   callback: @escaping ScreenResultCallback<TripSummaryResult>) -> Screen
}
