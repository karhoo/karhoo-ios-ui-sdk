//
//  LocationService.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import CoreLocation
import Foundation

public protocol LocationService {
    func locationAccessEnabled() -> Bool
}
