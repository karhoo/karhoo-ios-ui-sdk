//
//  MockLocationPermissionProvider.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 08/09/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

class MockLocationPermissionProvider: LocationPermissionProvider {
    var isLocationPermissionGrantedReturn = true
    var isLocationPermissionGranted: Bool { isLocationPermissionGrantedReturn }
}
