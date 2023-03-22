//
//  BraintreePaymentManager.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 13/05/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import KarhooUISDK // Even if the import may not be required in some configurations, it is needed for SPM linking. Do not remove unless you are sure a new solution allowes SPM-based project/app to be compiled.

public class BraintreePaymentManager: PaymentManager {
    public init() {}
    public let threeDSecureProvider: ThreeDSecureProvider? = BraintreeThreeDSecureProvider()
    public let cardFlow: CardRegistrationFlow = BraintreeCardRegistrationFlow()
    public let nonceProvider: PaymentNonceProvider = BraintreePaymentNonceProvider()
    public func getMetaWithUpdateTripIdIfRequired(meta:[String: Any], nonce: String) -> [String: Any] {
        meta
    }
}
