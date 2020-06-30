//
//  MockUserLocationProvider.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import CoreLocation
import KarhooSDK

class MockUserLocationProvider: UserLocationProvider {

    var locationChangedCallback: LocationProvidedClosure?
    var lastKnownLocation: CLLocation?

    func set(locationChangedCallback: LocationProvidedClosure?) {
        self.locationChangedCallback = locationChangedCallback
    }

    func getLastKnownLocation() -> CLLocation? {
        return lastKnownLocation
    }

    func triggerLocationCallback(location: CLLocation) {
        locationChangedCallback?(location)
    }
}
