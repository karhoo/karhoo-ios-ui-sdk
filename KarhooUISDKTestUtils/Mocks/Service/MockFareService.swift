//
//  MockFareService.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

@testable import KarhooUISDK

public class MockFareService: FareService {
    
    public let fareDetailsCall = MockCall<Fare>()
    public var fareDetailsCalled = false
    
    public func fareDetails(tripId: String) -> Call<Fare> {
        fareDetailsCalled = true
        return fareDetailsCall
    }
}
