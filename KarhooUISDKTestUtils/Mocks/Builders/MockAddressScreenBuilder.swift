//
//  MockAddressScreenBuilder.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
import KarhooSDK
import CoreLocation
@testable import KarhooUISDK

final public class MockAddressScreenBuilder: AddressScreenBuilder {
    public init() {}

    public var preferredLocationSet: CLLocation?
    public var addressModeSet: AddressType?
    public var callbackSet: ScreenResultCallback<LocationInfo>?
    public let returnScreen = UIViewController()

    public func buildAddressScreen(locationBias: CLLocation?,
                            addressType: AddressType,
                            callback: @escaping ScreenResultCallback<LocationInfo>) -> Screen {
        self.preferredLocationSet = locationBias
        self.addressModeSet = addressType
        self.callbackSet = callback

        return returnScreen
    }

    public func triggerAddressScreenResult(_ result: ScreenResult<LocationInfo>) {
        callbackSet?(result)
    }
}
