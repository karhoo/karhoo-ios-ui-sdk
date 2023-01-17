//
//  KarhooNewCheckoutPaymentWorker.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 17/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

final class KarhooNewCheckoutPaymentWorker {

    func getPaymentNonceAccordingToAuthState() -> Nonce? {
        .init(nonce: "", cardType: "", lastFour: "")
    }

    func getPaymentNonce() -> Nonce? {
        .init(nonce: "", cardType: "", lastFour: "")
    }
}
