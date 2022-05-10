//
// Created by Bartlomiej Sopala on 06/05/2022.
//

import Foundation
import KarhooSDK

public class AdyenPSPCore: PSPCore {

    public let shouldGetPaymentBeforeBook: Bool  = false
    public var shouldCheckThreeDBeforeBook: Bool = false

    public init() {
        
    }

    public func getCardFlow() -> CardRegistrationFlow {
        AdyenCardRegistrationFlow()
    }

    public func getNonceProvider() -> PaymentNonceProvider {
        AdyenPaymentNonceProvider()
    }

    public func  retrievePaymentNonce() -> String? {
        // TODO: implement
        return nil
    }

    public func getMetaWithUpdateTripIdIfRequired(meta:[String: Any], nonce: String) -> [String: Any] {
        var mutableMeta = meta
        mutableMeta["trip_id"] = nonce
        return mutableMeta
    }
}

public class BraintreePSPCore: PSPCore {

    public let shouldGetPaymentBeforeBook: Bool  = true
    public var shouldCheckThreeDBeforeBook: Bool = true

    public func getCardFlow() -> CardRegistrationFlow {
        BraintreeCardRegistrationFlow()
    }

    public func getNonceProvider() -> PaymentNonceProvider {
        BraintreePaymentNonceProvider()
    }

    public func  retrievePaymentNonce() -> String? {
        // TODO: implement
        return nil
    }

    public func getMetaWithUpdateTripIdIfRequired(meta:[String: Any], nonce: String) -> [String: Any] {
        meta
    }
}
