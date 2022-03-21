//
//  LocationInfo+Extensions.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 09.03.2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

extension LocationInfo {
    func toTripLocationDetails() -> TripLocationDetails {
        TripLocationDetails(
            displayAddress: self.address.displayAddress,
            placeId: self.placeId,
            position: self.position,
            timeZoneIdentifier: self.timeZoneIdentifier
        )
    }
}
