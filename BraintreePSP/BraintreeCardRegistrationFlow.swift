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
        callback: @escaping (OperationResult<CardFlowResult>) -> Void
    ) {
        self.callback = callback

        if showUpdateCardAlert {
            baseViewController?.showUpdatePaymentCardAlert(
                updateCardSelected: { [weak self] in
                    self?.startUpdateCardFlow(
                        organisationId: self?.organisationId() ?? "",
                        currencyCode: cardCurrency
                    )
                },
                cancelSelected: { [weak self] in
                    self?.callback?(.cancelledByUser)
                }
            )
        } else {
            startUpdateCardFlow(organisationId: organisationId(), currencyCode: cardCurrency)
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

    private func startUpdateCardFlow(organisationId: String, currencyCode: String) {
        let sdkTokenRequest = PaymentSDKTokenPayload(organisationId: organisationId,
                                                     currency: currencyCode)

        paymentService.initialisePaymentSDK(paymentSDKTokenPayload: sdkTokenRequest).execute { [weak self] result in
            if let token = result.getSuccessValue() {
                self?.buildBraintreeUI(paymentsToken: token)
            } else {
                self?.baseViewController?.showAlert(title: UITexts.Generic.error,
                                          message: UITexts.Errors.missingPaymentSDKToken,
                                          error: result.getErrorValue())
                self?.callback?(.completed(value: .didFailWithError(result.getErrorValue())))
            }
        }
    }

    private func buildBraintreeUI(paymentsToken: PaymentSDKToken) {
        let isGuest = Karhoo.configuration.authenticationMethod().isGuest()
        paymentScreenBuilder.buildAddCardScreen(
            allowToSaveCard: !isGuest,
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
            self.callback?(OperationResult.completed(value: .didAddPaymentMethod(nonce: braintreePaymentNonce)))
        }
    }

    private func dismissBraintreeUI() {
        baseViewController?.dismiss(animated: true, completion: nil)
    }
}
