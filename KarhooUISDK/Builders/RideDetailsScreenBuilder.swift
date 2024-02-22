//
//  RideDetailsScreenBuilder.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import CoreLocation
import Foundation
import KarhooSDK

public protocol RideDetailsScreenBuilder {
    func buildRideDetailsScreen(trip: TripInfo,
                                callback: @escaping ScreenResultCallback<RideDetailsAction>) -> Screen

    func buildOverlayRideDetailsScreen(trip: TripInfo,
                                       callback: @escaping ScreenResultCallback<RideDetailsAction>) -> Screen
}
