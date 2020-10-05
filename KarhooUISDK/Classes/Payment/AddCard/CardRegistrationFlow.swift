//
//  CardRegistrationFlow.swift
//  KarhooUISDK
//
//  Created by Jeevan Thandi on 21/09/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

public protocol CardRegistrationFlow {
    func setBaseView(_ baseViewController: BaseViewController?)
    func start(cardCurrency: String,
               showUpdateCardAlert: Bool,
               callback: @escaping (OperationResult<CardFlowResult>) -> Void)
}

public enum CardFlowResult {
    case didAddPaymentMethod(method: PaymentMethod)
    case didFailWithError(_ error: KarhooError?)
    case cancelledByUser
}

final class CardRegistrationFlowProvider {

    private let userService: UserService

    init(userService: UserService = Karhoo.getUserService()) {
        self.userService = userService
    }

    func getCardFlow() -> CardRegistrationFlow {
        if userService.getCurrentUser()?.paymentProvider?.provider.type == .adyen {
            return AdyenCardRegistrationFlow()
        } else {
            return BraintreeCardRegistrationFlow()
        }
    }

    func nonceProvider() -> PaymentNonceProvider {
        if userService.getCurrentUser()?.paymentProvider?.provider.type == .adyen {
            return AdyenPaymentNonceProvider()
        }

        return BraintreePaymentNonceProvider()
    }
}
