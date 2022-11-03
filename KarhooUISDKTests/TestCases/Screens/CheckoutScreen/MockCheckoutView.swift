//
//  MockCheckoutView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import KarhooUISDKTestUtils
@testable import KarhooUISDK

final class MockCheckoutView: MockBaseViewController, CheckoutView {
    var setRequestedStateCalled = false
    func setRequestedState() {
        setRequestedStateCalled = true
    }
    
    var getLoyaltyNonceCalled = false
    func getLoyaltyNonce(completion: @escaping (Result<LoyaltyNonce>) -> Void) {
        getLoyaltyNonceCalled = true
        let nonce = LoyaltyNonce(loyaltyNonce: TestUtil.getRandomString())
        completion(Result.success(result: nonce))
    }
    
    var showCheckoutView = false
    var showCheckoutViewValue = false
    func showCheckoutView(_ show: Bool) {
        showCheckoutView = true
        showCheckoutViewValue = show
    }

    var fadeOutCalled = false
    func fadeOut() {
        fadeOutCalled = true
    }
    
    var setRequestingStateCalled = false
    func setRequestingState() {
        setRequestingStateCalled = true
    }
    
    var priceString: String?
    func set(price: String?) {
        priceString = price
    }
    
    var asapQtaString: String?
    func setAsapState(qta: String?) {
        asapQtaString = qta
    }
    
    var details: PassengerDetails?
    func setPassenger(details: PassengerDetails?) {
        self.details = details
    }
    
    var setMoreDetailsCalled = false
    func setMoreDetailsState() {
        setMoreDetailsCalled = true
    }
    
    var resetPaymentNonceCalled = false
    func resetPaymentNonce() {
        resetPaymentNonceCalled = true
    }
    
    var timeStringSet: String?
    var dateStringSet: String?
    func setPrebookState(timeString: String?, dateString: String?) {
        timeStringSet = timeString
        dateStringSet = dateString
    }
        
    var setDefaultStateCalled = false
    func setDefaultState() {
        setDefaultStateCalled = true
    }
    
    var addFlightDetailsStateSet = false
    func setAddFlightDetailsState() {
        addFlightDetailsStateSet = true
    }
    
    var quoteType: String?
    func set(quoteType: String) {
        self.quoteType = quoteType
    }
    
    var baseFareHiddenSet: Bool?
    func set(baseFareExplanationHidden: Bool) {
        baseFareHiddenSet = baseFareExplanationHidden
    }

    var theQuoteSet: Quote?
    var loyaltyIdSet: String?
    var showLoyaltySet:  Bool?
    func set(quote: Quote, showLoyalty: Bool, loyaltyId: String?) {
        theQuoteSet = quote
        loyaltyIdSet = loyaltyId
        showLoyaltySet = showLoyalty
    }

    var isCheckoutViewVisible = false
    func isCheckoutViewVisible(_ show: Bool) {
        isCheckoutViewVisible = show
    }

    var retryAddPaymentMethodCalled = false
    func retryAddPaymentMethod(showRetryAlert: Bool) {
        retryAddPaymentMethodCalled = true
    }

    var passengerDetailsToReturn: PassengerDetails?
    func getPassengerDetails() -> PassengerDetails? {
        return passengerDetailsToReturn
    }

    var paymentNonceToReturn: Nonce?
    func getPaymentNonce() -> Nonce? {
        return paymentNonceToReturn
    }
    
    var commentsToReturn: String?
    func getComments() -> String? {
        return commentsToReturn
    }
    
    var flightNumberToReturn: String?
    func getFlightNumber() -> String? {
        return flightNumberToReturn
    }

    private(set) var paymentViewHiddenSet: Bool?
    func paymentView(hidden: Bool) {
        paymentViewHiddenSet = hidden
    }

    private(set) var quoteDidExpireCalled: Bool = false
    func quoteDidExpire() {
        quoteDidExpireCalled = true
    }

    var areTermsAndConditionsAcceptedToReturn: Bool = false
    var areTermsAndConditionsAccepted: Bool { areTermsAndConditionsAcceptedToReturn }
    
    var showTermsConditionsRequiredErrorCalled: Bool = false
    func showTermsConditionsRequiredError() {
        showTermsConditionsRequiredErrorCalled = true
    }
}
