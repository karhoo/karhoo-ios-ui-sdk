//
//  AdyenPaymentNonceProvider.swift
//  KarhooUISDK
//
//  Created by Jeevan Thandi on 30/09/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

final class AdyenPaymentNonceProvider: PaymentNonceProvider {

    private var baseViewController: BaseViewController?
    private let cardFlow: CardRegistrationFlow

    init(cardFlow: CardRegistrationFlow = AdyenCardRegistrationFlow()) {
        self.cardFlow = cardFlow
    }

    func getPaymentNonce(user: UserInfo,
                         organisation: Organisation,
                         quote: Quote,
                         result: @escaping (OperationResult<PaymentNonceProviderResult>) -> Void) {

        cardFlow.start(cardCurrency: quote.price.currencyCode,
                       amount: quote.price.intHighPrice,
                       showUpdateCardAlert: false,
                       callback: { result in
                        print("card result: ", result)
                       })
    }

    func set(baseViewController: BaseViewController) {
        cardFlow.setBaseView(baseViewController)
    }
}
