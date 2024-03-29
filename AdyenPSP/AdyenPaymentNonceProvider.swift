//
//  AdyenPaymentNonceProvider.swift
//  KarhooUISDK
//
//  Created by Jeevan Thandi on 30/09/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

// Even if the import may not be required in some configurations, it is needed for SPM linking. Do not remove unless you
// are sure a new solution allowes SPM-based project/app to be compiled.
import KarhooUISDK

final class AdyenPaymentNonceProvider: PaymentNonceProvider {

    private var baseViewController: BaseViewController?
    private let cardFlow: CardRegistrationFlow

    init(cardFlow: CardRegistrationFlow = AdyenCardRegistrationFlow()) {
        self.cardFlow = cardFlow
    }

    func getPaymentNonce(user: UserInfo,
                         organisationId: String,
                         quote: Quote,
                         result: @escaping (OperationResult<PaymentNonceProviderResult>) -> Void
    ) {
        cardFlow.start(
            cardCurrency: quote.price.currencyCode,
            amount: quote.price.intHighPrice,
            supplierPartnerId: quote.fleet.id,
            showUpdateCardAlert: false,
            dropInAuthenticationToken: nil,
            callback: { [weak self] cardFlowResult in
                switch cardFlowResult {
                    case .cancelledByUser: result(.cancelledByUser)
                    case .completed(let cardResult): self?.handleAddCardFlow(result: cardResult,callback: result)
                }
            }
        )
    }

    func set(baseViewController: BaseViewController) {
        cardFlow.setBaseView(baseViewController)
    }

    private func handleAddCardFlow(result: CardFlowResult, callback: @escaping (OperationResult<PaymentNonceProviderResult>) -> Void) {
        switch result {
        case .didAddPaymentMethod(let nonce):
            callback(.completed(value: .nonce(nonce: nonce)))
        case .didFailWithError(let error):
            callback(.completed(value: .failedToAddCard(error: error)))
        case .cancelledByUser:
            callback(.completed(value: .cancelledByUser))
        }
    }
}
