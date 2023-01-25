//
//  KarhooNewCheckoutLoyaltyWorker.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 17/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

protocol NewCheckoutLoyaltyWorker: AnyObject {
    func getLoyaltyNonce(completion: @escaping (Result<LoyaltyNonce>) -> Void)
}

final class KarhooNewCheckoutLoyaltyWorker: NewCheckoutLoyaltyWorker {

    func getLoyaltyNonce(completion: @escaping (Result<LoyaltyNonce>) -> Void) {
        assertionFailure()
        completion(.failure(error: nil))
    }
}
