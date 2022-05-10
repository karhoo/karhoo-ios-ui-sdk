//
// Created by Bartlomiej Sopala on 06/05/2022.
//

import Foundation
import KarhooSDK

public class AdyenPSPCore: PaymentManager {

    public init() {}
    public let shouldGetPaymentBeforeBook: Bool  = false
    public var shouldCheckThreeDSBeforeBook: Bool = false
    public let getCardFlow: CardRegistrationFlow = AdyenCardRegistrationFlow()
    public let getNonceProvider: PaymentNonceProvider = AdyenPaymentNonceProvider()
    public func getMetaWithUpdateTripIdIfRequired(meta:[String: Any], nonce: String) -> [String: Any] {
        var mutableMeta = meta
        mutableMeta["trip_id"] = nonce
        return mutableMeta
    }
}

public class BraintreePSPCore: PaymentManager {
    public init() {}
    public let shouldGetPaymentBeforeBook: Bool  = true
    public let shouldCheckThreeDSBeforeBook: Bool = true
    public let getCardFlow: CardRegistrationFlow = BraintreeCardRegistrationFlow()
    public let getNonceProvider: PaymentNonceProvider = BraintreePaymentNonceProvider()
    public func getMetaWithUpdateTripIdIfRequired(meta:[String: Any], nonce: String) -> [String: Any] {
        meta
    }
}
