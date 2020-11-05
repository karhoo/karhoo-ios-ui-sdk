//
//  JourneySummaryScreenFactory.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

internal protocol JourneySummaryScreenBuilder {
    func buildJourneySummaryScreen(trip: TripInfo,
                                   callback: @escaping ScreenResultCallback<TripSummaryResult>) -> Screen
}
