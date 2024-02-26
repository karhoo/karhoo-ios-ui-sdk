//
//  MockRideDetailsScreenBuilder.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit

@testable import KarhooUISDK

final public class MockRideDetailsScreenBuilder: RideDetailsScreenBuilder {
    public init() {}

    public var rideDetailsScreenTrip: TripInfo?
    private var rideDetailsScreenCallback: ScreenResultCallback<RideDetailsAction>?
    public let rideDetailsViewController = UIViewController()
    public func buildRideDetailsScreen(trip: TripInfo,
                                callback: @escaping ScreenResultCallback<RideDetailsAction>) -> Screen {
        rideDetailsScreenTrip = trip
        rideDetailsScreenCallback = callback
        return rideDetailsViewController
    }

    public var overlayTripSet: TripInfo?
    private var overlayCallbackSet: ScreenResultCallback<RideDetailsAction>?
    public let overlayReturnViewController = UIViewController()

    public func buildOverlayRideDetailsScreen(trip: TripInfo,
                                       callback: @escaping ScreenResultCallback<RideDetailsAction>) -> Screen {
        overlayTripSet = trip
        overlayCallbackSet = callback
        return overlayReturnViewController
    }

    public func triggerRideDetailsOverlayResult(_ result: ScreenResult<RideDetailsAction>) {
        overlayCallbackSet?(result)
    }

    public func triggerRideDetailsScreenResult(_ result: ScreenResult<RideDetailsAction>) {
        rideDetailsScreenCallback?(result)
    }
}
