//
//  MockAddressMapView.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

final class MockAddressMapView: AddressMapView {

    func set(actions: AddressMapActions, addressType: AddressType) {}

    func mapView() -> MapView {
        return MockKarhooMapView()
    }

    private(set) var addressBarTextSet: String?
    func set(addressBarText: String) {
        addressBarTextSet = addressBarText
    }
}
