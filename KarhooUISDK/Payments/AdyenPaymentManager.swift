//
// Created by Bartlomiej Sopala on 06/05/2022.
//

import Foundation
import KarhooSDK

public class AdyenPaymentManager: PaymentManager {

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

