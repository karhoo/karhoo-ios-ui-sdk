//
//  KarhooPaymentPresenter.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

final class KarhooPaymentPresenter: PaymentPresenter {

    private let analyticsService: AnalyticsService
    private let userService: UserService
    private let view: PaymentView
    private var cardRegistrationFlow: CardRegistrationFlow

     init(analyticsService: AnalyticsService = Karhoo.getAnalyticsService(),
          userService: UserService = Karhoo.getUserService(),
          cardRegistrationFlow: CardRegistrationFlow = PaymentFactory().getCardFlow(),
          view: PaymentView = KarhooAddCardView()) {
        self.cardRegistrationFlow = cardRegistrationFlow
        self.analyticsService = analyticsService
        self.userService = userService
        self.view = view
        self.userService.add(observer: self)
        displayAvailablePaymentMethod()
    }

    func updateCardPressed(showRetryAlert: Bool) {
        self.cardRegistrationFlow.setBaseView(view.baseViewController)
        analyticsService.send(eventName: .changePaymentDetailsPressed, payload: [String: Any]())

        let currencyCode = view.quote?.price.currencyCode ?? "GBP"
        let amount = view.quote?.price.intHighPrice ?? 0
        let supplierPartnerId = view.quote?.fleet.id ?? ""

        cardRegistrationFlow.start(cardCurrency: currencyCode,
                                   amount: amount,
                                   supplierPartnerId: supplierPartnerId,
                                   showUpdateCardAlert: showRetryAlert,
                                   callback: { [weak self] result in
                                    guard let cardFlowResult = result.completedValue() else {
                                        return
                                    }
                                    self?.handleAddCardFlow(result: cardFlowResult)
        })
    }

    private func displayAvailablePaymentMethod() {
        guard let currentNonce = userService.getCurrentUser()?.nonce else {
            view.noPaymentMethod()
            return
        }
        view.set(nonce: currentNonce)
    }

    private func handleAddCardFlow(result: CardFlowResult) {
        switch result {
        case .didFailWithError(let error):
            (view.parentViewController as? BaseViewController)?.showAlert(title: UITexts.Errors.somethingWentWrong,
                                                                          message: error?.message ?? "", error: error)
        default: break
        }
    }
}

extension KarhooPaymentPresenter: UserStateObserver {

    func userStateUpdated(user: UserInfo?) {
        displayAvailablePaymentMethod()
    }
}
