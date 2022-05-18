//
// Created by Bartlomiej Sopala on 06/05/2022.
//

import Foundation
import KarhooSDK

public class AdyenPaymentManager: PaymentManager {

    public init() {}
    public let shouldGetPaymentBeforeBooking: Bool  = false
    public var shouldCheckThreeDSBeforeBooking: Bool = false
    public let cardFlow: CardRegistrationFlow = AdyenCardRegistrationFlow()
    public let nonceProvider: PaymentNonceProvider = AdyenPaymentNonceProvider()
    public func getMetaWithUpdateTripIdIfRequired(meta: [String: Any], nonce: String) -> [String: Any] {
        var mutableMeta = meta
        mutableMeta["trip_id"] = nonce
        return mutableMeta
    }
}
