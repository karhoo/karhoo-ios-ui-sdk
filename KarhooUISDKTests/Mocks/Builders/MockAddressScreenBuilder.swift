//
//  MockAddressScreenBuilder.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK
import CoreLocation

@testable import KarhooUISDK

final class MockAddressScreenBuilder: AddressScreenBuilder {

    private(set) var preferredLocationSet: CLLocation?
    private(set) var addressModeSet: AddressType?
    private(set) var callbackSet: ScreenResultCallback<LocationInfo>?
    let returnScreen = UIViewController()

    func buildAddressScreen(locationBias: CLLocation?,
                            addressType: AddressType,
                            callback: @escaping ScreenResultCallback<LocationInfo>) -> Screen {
        self.preferredLocationSet = locationBias
        self.addressModeSet = addressType
        self.callbackSet = callback

        return returnScreen
    }

    func triggerAddressScreenResult(_ result: ScreenResult<LocationInfo>) {
        callbackSet?(result)
    }
}
