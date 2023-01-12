//
//  KarhooNewCheckoutPaymentWorker.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 12/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit
import SwiftUI

final class KarhooNewCheckoutPaymentWorker {

    private var paymentNonce: Nonce?

    func getPaymentNonce() -> Nonce? {
        paymentNonce
    }

    func set(nonce: Nonce) {
        paymentNonce = nonce
    }

    func resetPaymentNonce() {
        paymentNonce = nil
    }
}
