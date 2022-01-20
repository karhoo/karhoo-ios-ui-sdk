//
//  MockPassengerDetailsDelegate.swift
//  KarhooUISDKTests
//
//  Created by Diana Petrea on 20.01.2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooUISDK

final class MockPassengerDetailsDelegate: PassengerDetailsDelegate {
    
    var didInputPassengerDetailsCalled = false
    var details : PassengerDetailsResult?
    func didInputPassengerDetails(result: PassengerDetailsResult) {
        didInputPassengerDetailsCalled = true
        details = result
    }
    
    var didCancelInputCalled = false
    func didCancelInput(byUser: Bool) {
        didCancelInputCalled = true
    }
}
