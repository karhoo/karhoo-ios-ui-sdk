//
//  TripLocationDetailsExt.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

extension TripLocationDetails {

    func timezone() -> TimeZone {
        guard let defaultTimeZone = TimeZone(identifier: self.timeZoneIdentifier) else {
            return TimeZone.current
        }

        return defaultTimeZone
    }

    func toLocationInfo() -> LocationInfo {
        let locationDetailsAddress = LocationInfoAddress(displayAddress: self.displayAddress)
        return LocationInfo(placeId: self.placeId,
                            timeZoneIdentifier: self.timeZoneIdentifier,
                            position: self.position,
                            address: locationDetailsAddress)
    }
}
