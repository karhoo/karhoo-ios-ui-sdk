//
//  KarhooConfig.swift
//  Client
//
//  Created by Jo Santamaria on 27/01/2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK
import KarhooUISDK

final class KarhooConfig: KarhooUISDKConfiguration {
    static var auth: AuthenticationMethod = .karhooUser
    static var environment: KarhooEnvironment = .sandbox
    static var isExplicitTermsAndConditionsApprovalRequired: Bool = false
    static var paymentManager: PaymentManager!
    static var onUpdateAuthentication: (@escaping () -> Void) -> Void = { $0() }

    var isExplicitTermsAndConditionsConsentRequired: Bool { KarhooConfig.isExplicitTermsAndConditionsApprovalRequired }

    func environment() -> KarhooEnvironment {
        return KarhooConfig.environment
    }

    func authenticationMethod() -> AuthenticationMethod {
        return KarhooConfig.auth
    }
    
    var paymentManager: PaymentManager {
        KarhooConfig.paymentManager
    }

    func analytics() -> Analytics {
        TemporarAnalytics()
//        KarhooAnalytics(base: KarhooAnalitycsServiceWithNotifications() )
    }

    func requireSDKAuthentication(callback: @escaping () -> Void) {
        print("Client: KarhooConfig.requireSDKAuthentication started")
        KarhooConfig.onUpdateAuthentication {
            print("Client: KarhooConfig.requireSDKAuthentication finished")
            callback()
        }
    }
}

class TemporarAnalytics: Analytics {
    func tripStateChanged(tripState: KarhooSDK.TripInfo?) {
    }
    func fleetsShown(quoteListId: String?, amountShown: Int) {
    }
    func prebookOpened() {
    }
    func prebookSet(date: Date, timezone: String) {
    }
    func userCalledDriver(trip: KarhooSDK.TripInfo?) {
    }
    func pickupAddressSelected(locationDetails: KarhooSDK.LocationInfo) {
    }
    func destinationAddressSelected(locationDetails: KarhooSDK.LocationInfo) {
    }
    func bookingRequested(quoteId: String) {
    }
    func bookingSuccess(tripId: String, quoteId: String?, correlationId: String?) {
    }
    func bookingFailure(quoteId: String?, correlationId: String?, message: String, lastFourDigits: String, paymentMethodUsed: String, date: Date, amount: Double, currency: String) {
    }
    func cardAuthorisationFailure(quoteId: String?, errorMessage: String, lastFourDigits: String, paymentMethodUsed: String, date: Date, amount: Double, currency: String) {
    }
    func cardAuthorisationSuccess(quoteId: String) {
    }
    func loyaltyStatusRequested(quoteId: String?, correlationId: String?, loyaltyName: String?, loyaltyStatus: KarhooSDK.LoyaltyStatus?, errorSlug: String?, errorMessage: String?) {
    }
    func loyaltyPreAuthFailure(quoteId: String?, correlationId: String?, preauthType: KarhooUISDK.LoyaltyMode, errorSlug: String?, errorMessage: String?) {
    }
    func loyaltyPreAuthSuccess(quoteId: String?, correlationId: String?, preauthType: KarhooUISDK.LoyaltyMode) {

    }
    func trackTripOpened(tripDetails: KarhooSDK.TripInfo, isGuest: Bool) {

    }
    func pastTripsOpened() {

    }
    func upcomingTripsOpened() {
    }
    func trackTripClicked(tripDetails: KarhooSDK.TripInfo) {
    }
    func contactFleetClicked(page: KarhooUISDK.AnalyticsScreen, tripDetails: KarhooSDK.TripInfo) {
    }
    func contactDriverClicked(page: KarhooUISDK.AnalyticsScreen, tripDetails: KarhooSDK.TripInfo) {
    }
    func bookingScreenOpened() {
    }
    func checkoutOpened(_ quote: KarhooSDK.Quote) {
    }
    func quoteListOpened(_ journeyDetails: KarhooUISDK.JourneyDetails) {
    }
    func changePaymentDetailsPressed() {
    }
}
