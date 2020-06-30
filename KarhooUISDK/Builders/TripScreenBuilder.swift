//
//  TripScreenBuilder.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

public protocol TripScreenBuilder {
    func buildTripScreen(trip: TripInfo,
                         callback: @escaping ScreenResultCallback<TripScreenResult>) -> Screen
}
