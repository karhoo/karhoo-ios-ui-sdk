//
//  AdyenCardRegistrationFlow.swift
//  KarhooUISDK
//
//  Created by Jeevan Thandi on 08/09/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import Adyen
import KarhooSDK

//TODO: verify if we can register a card without invoking a payment
final class AdyenCardRegistrationFlow: CardRegistrationFlow {

    private weak var baseViewController: BaseViewController?
    private let paymentService: PaymentService

    init(paymentService: PaymentService = Karhoo.getPaymentService()) {
        self.paymentService = paymentService
    }

    func setBaseView(_ baseViewController: BaseViewController?) {
        self.baseViewController = baseViewController
    }

    func start(cardCurrency: String,
               showUpdateCardAlert: Bool,
               callback: @escaping (OperationResult<CardFlowResult>) -> Void) {
        baseViewController?.showLoadingOverlay(true)

        paymentService.getAdyenPaymentMethods().execute(callback: { [weak self] result in
            self?.baseViewController?.showLoadingOverlay(false)
            switch result {
            case .success(let result):
                //TODO: change result to be Data and decode it according to: https://github.com/Adyen/adyen-ios#presenting-the-drop-in
                self?.startDropIn()
            case .failure(let error): callback(.completed(value: .didFailWithError(error)))
            }
        })
    }

    private func startDropIn() {

    }
}
