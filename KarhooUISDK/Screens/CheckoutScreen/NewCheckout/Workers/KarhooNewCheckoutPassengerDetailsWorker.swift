//
//  KarhooNewCheckoutPassengerDetailsWorker.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 16/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Combine
import KarhooSDK

final class KarhooNewCheckoutPassengerDetailsWorker {
    @Published var passengerDetails: PassengerDetails?

    init(details: PassengerDetails?) {
        self.passengerDetails = details
    }
}

extension KarhooNewCheckoutPassengerDetailsWorker: PassengerDetailsDelegate {
    func didInputPassengerDetails(result: PassengerDetailsResult) {
        passengerDetails = result.details
    }

    func didCancelInput(byUser: Bool) {
        // Nothing to do here
    }
}
