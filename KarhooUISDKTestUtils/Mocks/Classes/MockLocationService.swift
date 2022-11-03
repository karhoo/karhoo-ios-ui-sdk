//
//  MockLocationService.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

final public class MockLocationService: LocationService {
    public init() {}

    public var setLocationAccessEnabled: Bool?
    public func locationAccessEnabled() -> Bool {
        return setLocationAccessEnabled!
    }
}
