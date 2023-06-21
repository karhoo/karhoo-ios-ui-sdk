//
//  BraintreeCardRegistrationFlow.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK
import KarhooUISDK

public final class BraintreeCardRegistrationFlow: CardRegistrationFlow {

    private let paymentScreenBuilder: PaymentScreenBuilder
    private let paymentService: PaymentService
    private let analyticsService: AnalyticsService
    private weak var baseViewController: BaseViewController?
    private let userService: UserService
    private var callback: ((OperationResult<CardFlowResult>) -> Void)?

    public init(
        paymentScreenBuilder: PaymentScreenBuilder = BraintreePaymentScreenBuilder(),
        paymentService: PaymentService = Karhoo.getPaymentService(),
        userService: UserService = Karhoo.getUserService(),
        analytics: AnalyticsService = Karhoo.getAnalyticsService()
    ) {
        self.paymentScreenBuilder = paymentScreenBuilder
        self.paymentService = paymentService
        self.userService = userService
        self.analyticsService = analytics
    }

    public func setBaseView(_ baseViewController: BaseViewController?) {
        self.baseViewController = baseViewController
    }

    public func start(
        cardCurrency: String,
        amount: Int,
        supplierPartnerId: String,
        showUpdateCardAlert: Bool,
        dropInAuthenticationToken: PaymentSDKToken?,
        callback: @escaping (OperationResult<CardFlowResult>) -> Void
    ) {
        self.callback = callback

        if showUpdateCardAlert {
            baseViewController?.showUpdatePaymentCardAlert(
                updateCardSelected: { [weak self] in
                    self?.startUpdateCardFlow(
                        token: dropInAuthenticationToken,
                        organisationId: self?.organisationId() ?? "",
                        currencyCode: cardCurrency
                    )
                },
                cancelSelected: { [weak self] in
                    self?.callback?(.cancelledByUser)
                }
            )
        } else {
            startUpdateCardFlow(
                token: dropInAuthenticationToken,
                organisationId: organisationId(),
                currencyCode: cardCurrency
            )
        }
    }

    private func organisationId() -> String {
        if let guestId = Karhoo.configuration.authenticationMethod().guestSettings?.organisationId {
            return guestId
        } else if let userOrg = userService.getCurrentUser()?.organisations.first?.id {
            return userOrg
        }
        return ""
    }

    private func startUpdateCardFlow(token: PaymentSDKToken?, organisationId: String, currencyCode: String) {
        if let token = token {
            buildBraintreeUI(paymentsToken: token)
        } else {
            // TODO: check if better error exist
            baseViewController?.showAlert(
                title: UITexts.Generic.error,
                message: UITexts.Errors.missingPaymentSDKToken,
                error: nil
            )
            callback?(.completed(value: .didFailWithError(nil)))
        }
    }

    private func buildBraintreeUI(paymentsToken: PaymentSDKToken) {
        let isGuest = Karhoo.configuration.authenticationMethod().isGuest()
        paymentScreenBuilder.buildAddCardScreen(
            allowToSaveAndDeleteCard: !isGuest,
            paymentsToken: paymentsToken,
            paymentMethodAdded: { [weak self] result in
                self?.handleBraintreeUICompletion(result)
            },
            flowItemCallback: { [weak self] result in
                self?.didBuildBraintreeUIScreen(result)
            }
        )
    }

    private func didBuildBraintreeUIScreen(_ result: ScreenResult<Screen>) {
        guard let item = result.completedValue() else {
            baseViewController?.showAlert(
                title: UITexts.Generic.error,
                message: UITexts.Errors.missingPaymentSDKToken,
                error: result.errorValue()
            )
            return
        }
        baseViewController?.present(item, animated: true, completion: nil)
    }

    private func handleBraintreeUICompletion(_ result: ScreenResult<Nonce>) {
        switch result {
        case .cancelled:
            dismissBraintreeUI()
            self.callback?(.cancelledByUser)
        case .failed(let error):
            dismissBraintreeUI()
            analyticsService.send(eventName: .userCardRegistrationFailed)
            self.callback?(.completed(value: .didFailWithError(error)))
        case .completed(let braintreePaymentNonce):
            dismissBraintreeUI()
            analyticsService.send(eventName: .userCardRegistered)
            callback?(OperationResult.completed(value: .didAddPaymentMethod(nonce: braintreePaymentNonce)))
        }
    }

    private func dismissBraintreeUI() {
        baseViewController?.dismiss(animated: true, completion: nil)
    }
}
