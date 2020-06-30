//
//  MockLocationService.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

final class MockLocationService: LocationService {

    var setLocationAccessEnabled: Bool?
    func locationAccessEnabled() -> Bool {
        return setLocationAccessEnabled!
    }
}
