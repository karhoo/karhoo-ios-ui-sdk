//
// Created by Bartlomiej Sopala on 06/05/2022.
// Copyright (c) 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

public protocol PSPCore {
    func getCardFlow() -> CardRegistrationFlow                                      // PaymentFactory:25
    func getNonceProvider() -> PaymentNonceProvider                                 // PaymentFactory:35
    func retrievePaymentNonce() -> String?                                         //KarhooCheckoutPresenter:423
    func getMetaWithUpdateTripIdIfRequired(meta: [String: Any], nonce: String) -> [String: Any]                //KarhooCheckoutPresenter:329
    var shouldGetPaymentBeforeBook: Bool { get }
    var shouldCheckThreeDBeforeBook: Bool { get }
}
