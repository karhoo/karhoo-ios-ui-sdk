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

public class MockAnalytics: Analytics {
    public init() {}

    public var changePaymentDetailsCalled = false
    public func changePaymentDetailsPressed() {
        changePaymentDetailsCalled = true
    }
    public func bookingRequested(quoteId: String) {
        // TODO: write tests
    }
    
    public func bookingSuccess(tripId: String, quoteId: String?, correlationId: String?) {
        // TODO: write tests
        paymentSucceedCalled = true
    }
    
    public func bookingFailure(quoteId: String?, correlationId: String?, message: String, lastFourDigits: String, paymentMethodUsed: String, date: Date, amount: Double, currency: String) {
        // TODO: write tests
        paymentFailedCalled = true
    }
    
    public func cardAuthorisationFailure(quoteId: String?, errorMessage: String, lastFourDigits: String, paymentMethodUsed: String, date: Date, amount: Double, currency: String) {
        // TODO: write tests
    }
    
    public func cardAuthorisationSuccess(quoteId: String) {
        // TODO: write tests
    }
    
    public func loyaltyStatusRequested(quoteId: String?, correlationId: String?, loyaltyName: String?, loyaltyStatus: LoyaltyStatus?, errorSlug: String?, errorMessage: String?) {
        // TODO: write tests
    }
    
    public func loyaltyPreAuthFailure(quoteId: String?, correlationId: String?, preauthType: LoyaltyMode, errorSlug: String?, errorMessage: String?) {
        // TODO: write tests
    }
    
    public func loyaltyPreAuthSuccess(quoteId: String?, correlationId: String?, preauthType: LoyaltyMode) {
        // TODO: write tests
    }
    
    public var prebookSetCalled = false
    public func prebookSet(date: Date, timezone: String) {
        prebookSetCalled = true
    }
    
    public var userCalledDriverCalled = false
    public func userCalledDriver(trip: TripInfo?) {
        userCalledDriverCalled = true
    }
    
    public var pickupAddressSelectedCalled = false
    public func pickupAddressSelected(locationDetails: LocationInfo) {
        pickupAddressSelectedCalled = true
    }
    
    public var destinationAddressSelected = false
    public func destinationAddressSelected(locationDetails: LocationInfo) {
        destinationAddressSelected = true
    }
    
    public var tripStateChangedCalled = false
    public func tripStateChanged(tripState: TripInfo?) {
        tripStateChangedCalled = true
    }
    
    public var fleetsShownCalled = false
    public func fleetsShown(quoteListId: String?, amountShown: Int) {
        fleetsShownCalled = true
    }
    
    public var prebookOpenedCalled = false
    public func prebookOpened() {
        prebookOpenedCalled = true
    }
    
    public var returnRideRequestedCalled = false
    public func returnRideRequested() {
        returnRideRequestedCalled = true
    }
    
    public var rideSummaryExitCalled = false
    public func rideSummaryExited() {
        rideSummaryExitCalled = true
    }
    
    public var isChangeCardDetailsPressed = false
    public func changeCardDetailsPressed() {
        isChangeCardDetailsPressed = true
    }
    
    public var userPressedCurrentLocationWithAddressType: (called: Bool, addressType: String) = (called: false,
                                                                                          addressType: "")
    public func userPressedCurrentLocation(addressType: String) {
        userPressedCurrentLocationWithAddressType.called = true
        userPressedCurrentLocationWithAddressType.addressType = addressType
    }
    
    public var bookingRequestedWithDesinationCalled = false
    public func bookingRequested(destination: LocationInfo, dateScheduled: Date?, quote: Quote) {
        bookingRequestedWithDesinationCalled = true
    }
    
    public var bookingScreenOpenedCalled = false
    public func bookingScreenOpened() {
        bookingScreenOpenedCalled = true
    }
    
    public var quoteListOpenedCalled = false
    public func quoteListOpened(_ journeyDetails: JourneyDetails) {
        quoteListOpenedCalled = true
    }
    
    public var checkoutOpenedCalled = false
    public func checkoutOpened(_ quote: Quote) {
        checkoutOpenedCalled = true
    }
    
    public var bookingRequestedWithTripDetailsCalled: TripInfo?
    public func bookingRequested(tripDetails: TripInfo) {
        bookingRequestedWithTripDetailsCalled = tripDetails
    }
    
    public var paymentSucceedCalled = false
    public func paymentSucceed() {
        paymentSucceedCalled = true
    }
    
    public var paymentFailedCalled = false
    public func paymentFailed(message: String, last4Digits: String, date: Date, amount: String, currency: String) {
        paymentFailedCalled = true
    }
    
    public var trackTripOpenedCalled = false
    public func trackTripOpened(tripDetails: TripInfo, isGuest: Bool) {
        trackTripOpenedCalled = true
    }
    
    public var pastTripsOpenedCalled = false
    public func pastTripsOpened() {
        pastTripsOpenedCalled = true
    }
    
    public var upcomingTripsOpenedCalled = false
    public func upcomingTripsOpened() {
        upcomingTripsOpenedCalled = true
    }
    
    public var trackTripClickedCalled = false
    public func trackTripClicked(tripDetails: TripInfo) {
        trackTripClickedCalled = true
    }
    
    public var contactFleetClickedCalled: AnalyticsScreen?
    public func contactFleetClicked(page: AnalyticsScreen, tripDetails: TripInfo) {
        contactFleetClickedCalled = page
    }
    
    public var contactDriverClickedCalled: AnalyticsScreen?
    public func contactDriverClicked(page: AnalyticsScreen, tripDetails: TripInfo) {
        contactDriverClickedCalled = page
    }
}
