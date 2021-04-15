//
//  LocationDetailsExt.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

extension LocationInfo {
    func toAddress() -> Address {
        return Address(placeId: self.placeId,
                       displayAddress: self.address.displayAddress,
                       lineOne: self.address.lineOne,
                       timeZoneIdentifier: self.timeZoneIdentifier,
                       poiDetailsType: self.details.type)
    }
}
