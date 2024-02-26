//
//  CLLocationCoordinate2D+Equatable.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import CoreLocation
import Foundation

extension CLLocationCoordinate2D: Equatable {
    static public func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return
            lhs.latitude == rhs.latitude &&
                lhs.longitude == rhs.longitude
    }
}
