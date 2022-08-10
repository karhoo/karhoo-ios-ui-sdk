//
//  TestAnalytics.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK
@testable import KarhooUISDK

class MockAnalytics: Analytics {
    
    var changePaymentDetailsCalled = false
    func changePaymentDetailsPressed() {
        changePaymentDetailsCalled = true
    }
    func bookingRequested(quoteId: String) {
        // TODO: write tests
    }
    
    func bookingSuccess(tripId: String, quoteId: String?, correlationId: String?) {
        // TODO: write tests
        paymentSucceedCalled = true
    }
    
    func bookingFailure(quoteId: String?, correlationId: String?, message: String, lastFourDigits: String, paymentMethodUsed: String, date: Date, amount: Double, currency: String) {
        // TODO: write tests
        paymentFailedCalled = true
    }
    
    func cardAuthorisationFailure(quoteId: String?, errorMessage: String, lastFourDigits: String, paymentMethodUsed: String, date: Date, amount: Double, currency: String) {
        // TODO: write tests
    }
    
    func cardAuthorisationSuccess(quoteId: String) {
        // TODO: write tests
    }
    
    func loyaltyStatusRequested(quoteId: String?, correlationId: String?, loyaltyName: String?, loyaltyStatus: LoyaltyStatus?, errorSlug: String?, errorMessage: String?) {
        // TODO: write tests
    }
    
    func loyaltyPreAuthFailure(quoteId: String?, correlationId: String?, preauthType: LoyaltyMode, errorSlug: String?, errorMessage: String?) {
        // TODO: write tests
    }
    
    func loyaltyPreAuthSuccess(quoteId: String?, correlationId: String?, preauthType: LoyaltyMode) {
        // TODO: write tests
    }
    
    var prebookSetCalled = false
    func prebookSet(date: Date, timezone: String) {
        prebookSetCalled = true
    }
    
    var userCalledDriverCalled = false
    func userCalledDriver(trip: TripInfo?) {
        userCalledDriverCalled = true
    }
    
    var pickupAddressSelectedCalled = false
    func pickupAddressSelected(locationDetails: LocationInfo) {
        pickupAddressSelectedCalled = true
    }
    
    var destinationAddressSelected = false
    func destinationAddressSelected(locationDetails: LocationInfo) {
        destinationAddressSelected = true
    }
    
    var tripStateChangedCalled = false
    func tripStateChanged(tripState: TripInfo?) {
        tripStateChangedCalled = true
    }
    
    var fleetsShownCalled = false
    func fleetsShown(quoteListId: String?, amountShown: Int) {
        fleetsShownCalled = true
    }
    
    var prebookOpenedCalled = false
    func prebookOpened() {
        prebookOpenedCalled = true
    }
    
    var returnRideRequestedCalled = false
    func returnRideRequested() {
        returnRideRequestedCalled = true
    }
    
    var rideSummaryExitCalled = false
    func rideSummaryExited() {
        rideSummaryExitCalled = true
    }
    
    var isChangeCardDetailsPressed = false
    func changeCardDetailsPressed() {
        isChangeCardDetailsPressed = true
    }
    
    var userPressedCurrentLocationWithAddressType: (called: Bool, addressType: String) = (called: false,
                                                                                          addressType: "")
    func userPressedCurrentLocation(addressType: String) {
        userPressedCurrentLocationWithAddressType.called = true
        userPressedCurrentLocationWithAddressType.addressType = addressType
    }
    
    var bookingRequestedWithDesinationCalled = false
    func bookingRequested(destination: LocationInfo, dateScheduled: Date?, quote: Quote) {
        bookingRequestedWithDesinationCalled = true
    }
    
    var bookingScreenOpenedCalled = false
    func bookingScreenOpened() {
        bookingScreenOpenedCalled = true
    }
    
    var quoteListOpenedCalled = false
    func quoteListOpened(_ journeyDetails: JourneyDetails) {
        quoteListOpenedCalled = true
    }
    
    var checkoutOpenedCalled = false
    func checkoutOpened(_ quote: Quote) {
        checkoutOpenedCalled = true
    }
    
    var bookingRequestedWithTripDetailsCalled: TripInfo?
    func bookingRequested(tripDetails: TripInfo) {
        bookingRequestedWithTripDetailsCalled = tripDetails
    }
    
    var paymentSucceedCalled = false
    func paymentSucceed() {
        paymentSucceedCalled = true
    }
    
    var paymentFailedCalled = false
    func paymentFailed(message: String, last4Digits: String, date: Date, amount: String, currency: String) {
        paymentFailedCalled = true
    }
    
    var trackTripOpenedCalled = false
    func trackTripOpened(tripDetails: TripInfo, isGuest: Bool) {
        trackTripOpenedCalled = true
    }
    
    var pastTripsOpenedCalled = false
    func pastTripsOpened() {
        pastTripsOpenedCalled = true
    }
    
    var upcomingTripsOpenedCalled = false
    func upcomingTripsOpened() {
        upcomingTripsOpenedCalled = true
    }
    
    var trackTripClickedCalled = false
    func trackTripClicked(tripDetails: TripInfo) {
        trackTripClickedCalled = true
    }
    
    var contactFleetClickedCalled: AnalyticsScreen?
    func contactFleetClicked(page: AnalyticsScreen, tripDetails: TripInfo) {
        contactFleetClickedCalled = page
    }
    
    var contactDriverClickedCalled: AnalyticsScreen?
    func contactDriverClicked(page: AnalyticsScreen, tripDetails: TripInfo) {
        contactDriverClickedCalled = page
    }
}
