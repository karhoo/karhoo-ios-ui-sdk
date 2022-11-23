//
//  KarhooLocationPermissionProvider.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 16.11.2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import CoreLocation.CLLocationManager

protocol LocationPermissionProvider: AnyObject {
    var isLocationPermissionGranted: Bool { get }
}

final class KarhooLocationPermissionProvider: LocationPermissionProvider {
    var isLocationPermissionGranted: Bool {
        CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways
    }
}
