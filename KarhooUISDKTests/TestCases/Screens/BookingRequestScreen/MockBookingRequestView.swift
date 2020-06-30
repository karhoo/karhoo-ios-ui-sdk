//
//  BookingRequestScreen.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
@testable import KarhooUISDK

final class MockBookingRequestView: MockBaseViewController, BookingRequestView {

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
    func set(quote: Quote) {
        theQuoteSet = quote
    }
    
    var setPaymentDetails: Nonce?
    func setPaymentDetails(nonce: Nonce?) {
        setPaymentDetails = nonce
    }
    
    var isBookingRequestViewVisible = false
    func showBookingRequestView(_ show: Bool) {
    
        isBookingRequestViewVisible = show
    }

    var retryAddPaymentMethodCalled = false
    func retryAddPaymentMethod() {
        retryAddPaymentMethodCalled = true
    }

    var passengerDetailsToReturn: PassengerDetails?
    func getPassengerDetails() -> PassengerDetails {
        return passengerDetailsToReturn!
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
}
