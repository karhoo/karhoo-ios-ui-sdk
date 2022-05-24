//
//  BraintreePaymentManager.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 13/05/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import KarhooUISDK

public class BraintreePaymentManager: PaymentManager {
    public init() {}
    public var shouldCheckThreeDSBeforeBooking: Bool = true
    public let shouldGetPaymentBeforeBooking: Bool  = true
    public let getThreeDSecureProvider: ThreeDSecureProvider? = BraintreeThreeDSecureProvider()
    public let getCardFlow: CardRegistrationFlow = BraintreeCardRegistrationFlow()
    public let getNonceProvider: PaymentNonceProvider = BraintreePaymentNonceProvider()
    public func getMetaWithUpdateTripIdIfRequired(meta:[String: Any], nonce: String) -> [String: Any] {
        meta
    }
}
