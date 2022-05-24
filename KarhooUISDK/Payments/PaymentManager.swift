//
// Created by Bartlomiej Sopala on 06/05/2022.
// Copyright (c) 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

public protocol PaymentManager {
    var getCardFlow: CardRegistrationFlow { get }
    var getNonceProvider: PaymentNonceProvider { get }
    var getThreeDSecureProvider: ThreeDSecureProvider? { get }
    var shouldGetPaymentBeforeBooking: Bool { get }
    var shouldCheckThreeDSBeforeBooking: Bool { get }
    func getMetaWithUpdateTripIdIfRequired(meta: [String: Any], nonce: String) -> [String: Any]
}
