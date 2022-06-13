//
//  AdyenPaymentManager.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 13/05/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import KarhooUISDK

public class AdyenPaymentManager: PaymentManager {
    public init() {}
    public var shouldCheckThreeDSBeforeBooking: Bool = false
    public let shouldGetPaymentBeforeBooking: Bool  = false
    public let threeDSecureProvider: ThreeDSecureProvider? = nil
    public let cardFlow: CardRegistrationFlow = AdyenCardRegistrationFlow()
    public let nonceProvider: PaymentNonceProvider = AdyenPaymentNonceProvider()
    public func getMetaWithUpdateTripIdIfRequired(meta: [String: Any], nonce: String) -> [String: Any] {
        var mutableMeta = meta
        mutableMeta["trip_id"] = nonce
        return mutableMeta
    }
}
