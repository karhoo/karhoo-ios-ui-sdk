//
//  AdyenPaymentManager.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 13/05/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

public class AdyenPaymentManager: PaymentManager {

    public init() {}
    public let shouldGetPaymentBeforeBook: Bool  = false
    public var getThreeDSecureProvider: ThreeDSecureProvider? = nil
    public let getCardFlow: CardRegistrationFlow = AdyenCardRegistrationFlow()
    public let getNonceProvider: PaymentNonceProvider = AdyenPaymentNonceProvider()
    public func getMetaWithUpdateTripIdIfRequired(meta:[String: Any], nonce: String) -> [String: Any] {
        var mutableMeta = meta
        mutableMeta["trip_id"] = nonce
        return mutableMeta
    }
}
