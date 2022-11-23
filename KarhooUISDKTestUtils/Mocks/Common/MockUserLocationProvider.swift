//
//  MockUserLocationProvider.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import CoreLocation
import KarhooSDK

public class MockUserLocationProvider: UserLocationProvider {
    public init() {}

    public var locationChangedCallback: LocationProvidedClosure?
    public var lastKnownLocation: CLLocation?

    public func set(locationChangedCallback: LocationProvidedClosure?) {
        self.locationChangedCallback = locationChangedCallback
    }

    public func getLastKnownLocation() -> CLLocation? {
        return lastKnownLocation
    }

    public func triggerLocationCallback(location: CLLocation) {
        locationChangedCallback?(location)
    }
}
