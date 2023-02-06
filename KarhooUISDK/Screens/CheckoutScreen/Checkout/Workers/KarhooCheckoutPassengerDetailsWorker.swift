//
//  KarhooNewCheckoutPassengerDetailsWorker.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 16/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Combine
import KarhooSDK

final class KarhooCheckoutPassengerDetailsWorker {
    var passengerDetailsSubject: CurrentValueSubject<PassengerDetails?, Never>

    init(details: PassengerDetails?) {
        self.passengerDetailsSubject = CurrentValueSubject(details)
    }
}

extension KarhooCheckoutPassengerDetailsWorker: PassengerDetailsDelegate {
    func didInputPassengerDetails(result: PassengerDetailsResult) {
        passengerDetailsSubject.send(result.details)
    }

    func didCancelInput(byUser: Bool) {
        // Nothing to do here
    }
}
