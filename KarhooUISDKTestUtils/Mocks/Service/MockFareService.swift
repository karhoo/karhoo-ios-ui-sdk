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

class MockFareService: FareService {
    
    let fareDetailsCall = MockCall<Fare>()
    var fareDetailsCalled = false
    
    func fareDetails(tripId: String) -> Call<Fare> {
        fareDetailsCalled = true
        return fareDetailsCall
    }
}
