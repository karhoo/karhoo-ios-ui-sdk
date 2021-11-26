//
//  LocationService.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import CoreLocation

public protocol LocationService {
    func locationAccessEnabled() -> Bool
}
