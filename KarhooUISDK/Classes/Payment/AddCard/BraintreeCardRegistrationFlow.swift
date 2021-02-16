//
//  BraintreeCardRegistrationFlow.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK

public final class BraintreeCardRegistrationFlow: CardRegistrationFlow {

    private let paymentScreenBuilder: PaymentScreenBuilder
    private let paymentService: PaymentService
    private let analyticsService: AnalyticsService
    private weak var baseViewController: BaseViewController?
    private let userService: UserService
    private var callback: ((OperationResult<CardFlowResult>) -> Void)?

    public init(paymentScreenBuilder: PaymentScreenBuilder = UISDKScreenRouting.default.paymentScreen(),
                paymentService: PaymentService = Karhoo.getPaymentService(),
                userService: UserService = Karhoo.getUserService(),
                analytics: AnalyticsService = Karhoo.getAnalyticsService()) {
        self.paymentScreenBuilder = paymentScreenBuilder
        self.paymentService = paymentService
        self.userService = userService
        self.analyticsService = analytics
    }

    public func setBaseView(_ baseViewController: BaseViewController?) {
        self.baseViewController = baseViewController
    }

   public func start(cardCurrency: String,
                     amount: Int,
                     showUpdateCardAlert: Bool,
                     callback: @escaping (OperationResult<CardFlowResult>) -> Void) {
        self.callback = callback

        if showUpdateCardAlert {
            self.baseViewController?.showUpdatePaymentCardAlert(updateCardSelected: { [weak self] in
                self?.startUpdateCardFlow(organisationId: self?.organisationId() ?? "", currencyCode: cardCurrency)
                }, cancelSelected: { [weak self] in
                    self?.callback?(.cancelledByUser)
            })
        } else {
            self.startUpdateCardFlow(organisationId: organisationId(), currencyCode: cardCurrency)
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
            if let token = result.successValue() {
                self?.buildBraintreeUI(paymentsToken: token)
            } else {
                self?.baseViewController?.showAlert(title: UITexts.Generic.error,
                                          message: UITexts.Errors.missingPaymentSDKToken,
                                          error: result.errorValue())
                self?.callback?(.completed(value: .didFailWithError(result.errorValue())))
            }
        }
    }

    private func buildBraintreeUI(paymentsToken: PaymentSDKToken) {
        paymentScreenBuilder.buildAddCardScreen(paymentsToken: paymentsToken,
                                                paymentMethodAdded: { [weak self] result in
                                                    self?.handleBraintreeUICompletion(result)
            },
                                                flowItemCallback: { [weak self] result in
                                                    self?.didBuildBraintreeUIScreen(result)
        })
    }

    private func didBuildBraintreeUIScreen(_ result: ScreenResult<Screen>) {
        guard let item = result.completedValue() else {
            baseViewController?.showAlert(title: UITexts.Generic.error,
                                          message: UITexts.Errors.missingPaymentSDKToken,
                                          error: result.errorValue())
            return
        }

        baseViewController?.present(item, animated: true, completion: nil)
    }

    private func handleBraintreeUICompletion(_ result: ScreenResult<PaymentMethod>) {
        switch result {
        case .cancelled:
            dismissBraintreeUI()
            self.callback?(.cancelledByUser)
        case .failed(let error):
            dismissBraintreeUI()
            analyticsService.send(eventName: .userCardRegistrationFailed)
            self.callback?(.completed(value: .didFailWithError(error)))
        case .completed(let braintreePaymentMethod):

            dismissBraintreeUI()
            baseViewController?.showLoadingOverlay(true)

            if Karhoo.configuration.authenticationMethod().guestSettings != nil {
                registerGuestPayer(method: braintreePaymentMethod)
            } else {
                registerKarhooPayer(method: braintreePaymentMethod)
            }
        }
    }

    private func registerKarhooPayer(method: PaymentMethod) {
        guard let currentUser = userService.getCurrentUser() else {
            return
        }

        let payer = Payer(id: currentUser.userId,
                          firstName: currentUser.firstName,
                          lastName: currentUser.lastName,
                          email: currentUser.email)

        guard let payerOrg = currentUser.organisations.first else {
            return
        }

        let addPaymentPayload = AddPaymentDetailsPayload(nonce: method.nonce,
                                                         payer: payer,
                                                         organisationId: payerOrg.id)

        paymentService.addPaymentDetails(addPaymentDetailsPayload: addPaymentPayload)
            .execute(callback: { [weak self] result in
            self?.baseViewController?.showLoadingOverlay(false)

            guard let nonce = result.successValue() else {
                self?.baseViewController?.show(error: result.errorValue())
                self?.analyticsService.send(eventName: .userCardRegistrationFailed)
                self?.callback?(OperationResult.completed(value: .didFailWithError(result.errorValue())))
                return
            }

            self?.analyticsService.send(eventName: .userCardRegistered)
            self?.callback?(OperationResult.completed(
                value: .didAddPaymentMethod(method: PaymentMethod(nonce: nonce.nonce))))
        })

    }

    private func registerGuestPayer(method: PaymentMethod) {
        analyticsService.send(eventName: .userCardRegistered)
        self.baseViewController?.showLoadingOverlay(false)
        self.callback?(OperationResult.completed(value: .didAddPaymentMethod(method: method)))
    }

    private func dismissBraintreeUI() {
        baseViewController?.dismiss(animated: true, completion: nil)
    }
}
