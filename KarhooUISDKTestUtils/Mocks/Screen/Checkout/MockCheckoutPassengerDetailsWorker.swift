//
//  MockCheckoutPassengerDetailsWorker.swift
//  KarhooUISDKTestUtils
//
//  Created by Aleksander Wedrychowski on 07/02/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Combine
import KarhooSDK
@testable import KarhooUISDK

public class MockCheckoutPassengerDetailsWorker: CheckoutPassengerDetailsWorker {
    public init() {}
    public var passengerDetailsResult: KarhooUISDK.PassengerDetailsResult?
    public func didInputPassengerDetails(result: KarhooUISDK.PassengerDetailsResult) {
        passengerDetailsResult = result
    }

    public var didCancelInputCalled = false
    public var didCancelInputCalledByUser = false
    public func didCancelInput(byUser: Bool) {
        didCancelInputCalled = true
        didCancelInputCalledByUser = byUser
    }

    public var passengerDetailsSubject: CurrentValueSubject<PassengerDetails?, Never> = CurrentValueSubject<PassengerDetails?, Never>(nil)

    public func update(passengerDetails: PassengerDetails?) {
        passengerDetailsSubject.send(passengerDetails)
    }
}
