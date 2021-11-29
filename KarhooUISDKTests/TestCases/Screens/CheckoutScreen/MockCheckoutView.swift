//
//  MockCheckoutView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
@testable import KarhooUISDK

final class MockCheckoutView: MockBaseViewController, CheckoutView {
    
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
    func set(quote: Quote, loyaltyId: String) {
        theQuoteSet = quote
        loyaltyIdSet = loyaltyId
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

    var paymentNonceToReturn: String?
    func getPaymentNonce() -> String? {
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
}
