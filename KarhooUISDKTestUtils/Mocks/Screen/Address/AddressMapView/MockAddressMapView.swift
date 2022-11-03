//
//  MockAddressMapView.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

final public class MockAddressMapView: AddressMapView {

    public func set(actions: AddressMapActions, addressType: AddressType) {}

    public func mapView() -> MapView {
        return MockKarhooMapView()
    }

    public var addressBarTextSet: String?
    public func set(addressBarText: String) {
        addressBarTextSet = addressBarText
    }
}
