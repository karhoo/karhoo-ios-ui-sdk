//
//  RideDetailsScreenBuilder.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import CoreLocation

public protocol RideDetailsScreenBuilder {
    func buildRideDetailsScreen(trip: TripInfo,
                                callback: @escaping ScreenResultCallback<RideDetailsAction>) -> Screen

    func buildOverlayRideDetailsScreen(trip: TripInfo,
                                       callback: @escaping ScreenResultCallback<RideDetailsAction>) -> Screen
}
