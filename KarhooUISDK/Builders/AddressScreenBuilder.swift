//
//  AddressScreenFactory.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import CoreLocation

public protocol AddressScreenBuilder {
    func buildAddressScreen(locationBias: CLLocation?,
                            addressType: AddressType,
                            callback: @escaping ScreenResultCallback<LocationInfo>) -> Screen
}
