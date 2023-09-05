//
//  KarhooLocationService.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import CoreLocation

final public class KarhooLocationService: LocationService {
    let locationManager = CLLocationManager()
    
    public init() {}
    
    public func locationAccessEnabled() -> Bool {
        guard CLLocationManager.locationServicesEnabled() else {
            return false
        }

        return [.authorizedAlways, .authorizedWhenInUse].contains(locationManager.authorizationStatus)
    }
}
