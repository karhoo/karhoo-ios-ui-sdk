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
    func bookTripPressed()
    func addOrEditPassengerDetails()
    func addMoreDetails()
    func didAddPassengerDetails()
    func didPressFareExplanation()
    func didPressClose()
    func screenHasFadedOut()
    func isKarhooUser() -> Bool
    func updateBookButtonWithEnabledState()
}

protocol CheckoutView: BaseViewController {
    func showCheckoutView(_ show: Bool)
    func setRequestingState()
    func setAddFlightDetailsState()
    func setPassenger(details: PassengerDetails?)
    func setMoreDetailsState()
    func setDefaultState()
    func resetPaymentNonce()
    func set(quote: Quote, showLoyalty: Bool, loyaltyId: String?)
    func set(price: String?)
    func set(quoteType: String)
    func set(baseFareExplanationHidden: Bool)
    func setAsapState(qta: String?)
    func setPrebookState(timeString: String?, dateString: String?)
    func retryAddPaymentMethod(showRetryAlert: Bool)
    func getPaymentNonce() -> String?
    func getPassengerDetails() -> PassengerDetails?
    func getComments() -> String?
    func getFlightNumber() -> String?
    func getLoyaltyNonce(completion: @escaping (Result<LoyaltyNonce>) -> Void)
    func quoteDidExpire()
}

extension CheckoutView {
    func getComments() -> String? {
        return nil
    }
    
    func getFlightNumber() -> String? {
        return nil
    }
    
    func set(quote: Quote, showLoyalty: Bool, loyaltyId: String? = nil) {
        set(quote: quote, showLoyalty: showLoyalty, loyaltyId: loyaltyId)
    }
}
