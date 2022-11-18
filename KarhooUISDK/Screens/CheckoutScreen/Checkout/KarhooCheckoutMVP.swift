//
//  CheckoutMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

protocol CheckoutPresenter {
    func load(view: CheckoutView)
    func screenWillAppear()
    func completeBookingFlow()
    func addOrEditPassengerDetails()
    func addMoreDetails()
    func didAddPassengerDetails()
    func didPressFareExplanation()
    func didPressCloseOnExpirationAlert()
    func isKarhooUser() -> Bool
    func shouldRequireExplicitTermsAndConditionsAcceptance() -> Bool
    func updateBookButtonWithEnabledState()
    func didPressPayButton(showRetryAlert: Bool)
}

protocol CheckoutView: BaseViewController {
    var areTermsAndConditionsAccepted: Bool { get }
    func setRequestingState()
    func setRequestedState()
    func setAddFlightDetailsState()
    func setPassenger(details: PassengerDetails?)
    func setMoreDetailsState()
    func setDefaultState()
    func resetPaymentNonce()
    func set(quote: Quote, showLoyalty: Bool, loyaltyId: String?)
    func set(price: String?)
    func set(quoteType: String)
    func set(baseFareExplanationHidden: Bool)
    func set(nonce: Nonce)
    func setAsapState(qta: String?)
    func setPrebookState(timeString: String?, dateString: String?)
    func retryAddPaymentMethod(showRetryAlert: Bool)
    func getPaymentNonce() -> Nonce?
    func getPassengerDetails() -> PassengerDetails?
    func getComments() -> String?
    func getFlightNumber() -> String?
    func getLoyaltyNonce(completion: @escaping (Result<LoyaltyNonce>) -> Void)
    func quoteDidExpire()
    func showTermsConditionsRequiredError()
}

extension CheckoutView {
    func getComments() -> String? {
        nil
    }
    
    func getFlightNumber() -> String? {
        nil
    }
    
    func set(quote: Quote, showLoyalty: Bool, loyaltyId: String? = nil) {
        set(quote: quote, showLoyalty: showLoyalty, loyaltyId: loyaltyId)
    }
}
