//
//  MockRideDetailsScreenBuilder.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
import Foundation
import KarhooSDK

@testable import KarhooUISDK

final class MockRideDetailsScreenBuilder: RideDetailsScreenBuilder {

    private(set) var rideDetailsScreenTrip: TripInfo?
    private var rideDetailsScreenCallback: ScreenResultCallback<RideDetailsAction>?
    let rideDetailsViewController = UIViewController()
    func buildRideDetailsScreen(trip: TripInfo,
                                callback: @escaping ScreenResultCallback<RideDetailsAction>) -> Screen {
        rideDetailsScreenTrip = trip
        rideDetailsScreenCallback = callback
        return rideDetailsViewController
    }

    private(set) var overlayTripSet: TripInfo?
    private var overlayCallbackSet: ScreenResultCallback<RideDetailsAction>?
    let overlayReturnViewController = UIViewController()

    func buildOverlayRideDetailsScreen(trip: TripInfo,
                                       callback: @escaping ScreenResultCallback<RideDetailsAction>) -> Screen {
        overlayTripSet = trip
        overlayCallbackSet = callback
        return overlayReturnViewController
    }

    func triggerRideDetailsOverlayResult(_ result: ScreenResult<RideDetailsAction>) {
        overlayCallbackSet?(result)
    }

    func triggerRideDetailsScreenResult(_ result: ScreenResult<RideDetailsAction>) {
        rideDetailsScreenCallback?(result)
    }
}
