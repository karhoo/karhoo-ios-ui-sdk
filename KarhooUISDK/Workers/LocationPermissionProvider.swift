//
//  LocationPermissionProvider.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 08/09/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import CoreLocation

protocol LocationPermissionProvider: AnyObject {
    var isLocationPermissionGranted: Bool { get }
}

final class KarhooLocationPermissionProvider: LocationPermissionProvider {
    var isLocationPermissionGranted: Bool {
        CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways
    }
}
