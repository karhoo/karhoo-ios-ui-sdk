//
//  TripSummaryScreenBuilder.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

protocol TripSummaryScreenBuilder {
    func buildTripSummaryScreen(trip: TripInfo,
                                callback: @escaping ScreenResultCallback<TripSummaryResult>) -> Screen
}
