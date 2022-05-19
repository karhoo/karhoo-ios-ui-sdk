//
// Created by Bartlomiej Sopala on 06/05/2022.
// Copyright (c) 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

public protocol PaymentManager {
    var cardFlow: CardRegistrationFlow { get }
    var nonceProvider: PaymentNonceProvider { get }
    var shouldGetPaymentBeforeBooking: Bool { get }
    var shouldCheckThreeDSBeforeBooking: Bool { get }
    func getMetaWithUpdateTripIdIfRequired(meta: [String: Any], nonce: String) -> [String: Any]
<<<<<<< HEAD:KarhooUISDK/Controllers/Payment/PaymentManager.swift
    var shouldGetPaymentBeforeBook: Bool { get }
    var getThreeDSecureProvider: ThreeDSecureProvider? { get }
=======
>>>>>>> MOB-4091-multi-psp-contract:KarhooUISDK/Payments/PaymentManager.swift
}
