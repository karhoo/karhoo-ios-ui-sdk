//
//  AddressScreenBuilder.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import CoreLocation
import Foundation
import KarhooSDK

public protocol AddressScreenBuilder {
    func buildAddressScreen(locationBias: CLLocation?,
                            addressType: AddressType,
                            callback: @escaping ScreenResultCallback<LocationInfo>) -> Screen
}
