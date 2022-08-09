//
//  KarhooPaymentPresenter.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

final class KarhooAddPaymentPresenter: AddPaymentPresenter {

    private let analytics: Analytics
    private let userService: UserService
    private unowned let view: AddPaymentView
    private var cardRegistrationFlow: CardRegistrationFlow
    private var quote: Quote?

     init(analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics(),
          userService: UserService = Karhoo.getUserService(),
          cardRegistrationFlow: CardRegistrationFlow = PaymentFactory().getCardFlow(),
          view: AddPaymentView = KarhooAddPaymentView(),
          quote: Quote?) {
        self.cardRegistrationFlow = cardRegistrationFlow
        self.analytics = analytics
        self.userService = userService
        self.view = view
        self.quote = quote
        self.userService.add(observer: self)
        displayAvailablePaymentMethod()
    }

    func updateCardPressed(showRetryAlert: Bool) {
        cardRegistrationFlow.setBaseView(view.baseViewController)
        reportChangePaymentDetailsPressed()

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
        case .didAddPaymentMethod(let nonce):
            reportCardAuthorisationSuccess()
            view.set(nonce: nonce)
        case .didFailWithError(let error):
            reportCardAuthorisationFailure(message: error?.message ?? "")
            (view.parentViewController as? BaseViewController)?.showAlert(title: UITexts.Errors.somethingWentWrong,
                                                                          message: error?.message ?? "", error: error)
        default: break
        }
    }
    
    internal func setQuote(_ quote: Quote){
        self.quote = quote
    }

    // Analytics
    private func reportCardAuthorisationFailure(message: String) {
        analytics.cardAuthorisationFailure(
            quoteId: quote?.id ?? "",
            errorMessage: message,
            lastFourDigits: userService.getCurrentUser()?.nonce?.lastFour ?? "",
            paymentMethodUsed: String(describing: KarhooUISDKConfigurationProvider.configuration.paymentManager),
            date: Date(),
            amount: quote?.price.highPrice ?? -1,
            currency: quote?.price.currencyCode ?? ""
        )
    }

    private func reportCardAuthorisationSuccess(){
        analytics.cardAuthorisationSuccess(quoteId: quote?.id ?? "")
    }

    private func reportChangePaymentDetailsPressed(){
        analytics.changePaymentDetailsPressed()
    }
}

extension KarhooAddPaymentPresenter: UserStateObserver {

    func userStateUpdated(user: UserInfo?) {
        displayAvailablePaymentMethod()
    }
}
