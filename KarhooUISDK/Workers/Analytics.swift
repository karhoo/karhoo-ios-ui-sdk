//
//  Analytics.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK

public protocol Analytics {
    func tripStateChanged(tripState: TripInfo?)
    func fleetsShown(quoteListId: String?, amountShown: Int)
    func prebookOpened()
    func prebookSet(date: Date, timezone: String)
    func userCalledDriver(trip: TripInfo?)
    func pickupAddressSelected(locationDetails: LocationInfo)
    func destinationAddressSelected(locationDetails: LocationInfo)
    func bookingRequested(quoteId: String, correlationId: String)
    func bookingSucceed(tripId: String, quoteId: String, correlationId: String)
    func bookingFailure(quoteId: String, correlationId: String, message: String, lastFourDigits: String, paymentMethodUsed: String, date: Date, amount: String, currency: String)
    func cardAuthorisationFailure(quoteId: String, errorMessage: String, lastFourDigits: String, paymentMethodUsed: String, date: Date, amount: String, currency: String)
    func cardAuthorisationSuccess(quoteId: String)
    func loyaltyStatusRequested(quoteId: String, loyaltyName: String?, loyaltyStatus: LoyaltyStatus?, errorSlug: String?, errorMessage: String?, correlationId: String)
    func loyaltyPreAuthFailure(quoteId: String, correlationId: String, preauthType: LoyaltyMode, errorSlug: String?, errorMessage: String?)
    func loyaltyPreAuthSuccess(quoteId: String, correlationId: String, preauthType: LoyaltyMode)
    func trackTripOpened(tripDetails: TripInfo, isGuest: Bool)
    func pastTripsOpened()
    func upcomingTripsOpened()
    func trackTripClicked(tripDetails: TripInfo)
    func contactFleetClicked(page: AnalyticsScreen, tripDetails: TripInfo)
    func contactDriverClicked(page: AnalyticsScreen, tripDetails: TripInfo)
    func bookingScreenOpened()
    func checkoutOpened(_ quote: Quote)
    func quoteListOpened(_ journeyDetails: JourneyDetails)
}

public enum AnalyticsScreen: Equatable {
    case upcomingRides
    case vehicleTracking
}

final class KarhooAnalytics: Analytics {
    
    private let base: AnalyticsService
    private let emptyPayload = [String: Any]()
    private let timestampFormatter = TimestampFormatter()

    init(base: AnalyticsService = Karhoo.getAnalyticsService()) {
        self.base = base
    }

    func tripStateChanged(tripState: TripInfo?) {
        base.send(eventName: .stateChangeDisplayed,
                  payload: [Keys.tripState: tripState as Any])
    }
    
    func fleetsShown(quoteListId: String?, amountShown: Int) {
        base.send(eventName: .fleetListShown, payload: [
            Keys.quoteListId: quoteListId ?? "",
            Keys.amountShown: amountShown
        ])
    }

    func prebookOpened() {
            base.send(eventName: .prebookOpened, payload: emptyPayload)
    }

    func prebookSet(date: Date, timezone: String) {
        let timestamp = timestampFormatter.formattedDate(date)
        base.send(eventName: .prebookTimeSet, payload: [Keys.prebookTimeSet: timestamp,
                                                        Keys.timeZone: timezone])
    }

    func userCalledDriver(trip: TripInfo?) {
        base.send(eventName: .userCalledDriver, payload: [Keys.tripInfo: trip as Any])
    }

    func pickupAddressSelected(locationDetails: LocationInfo) {
        base.send(eventName: .pickupAddressSelected,
                  payload: [Keys.locationDetails: locationDetails])
    }

    func destinationAddressSelected(locationDetails: LocationInfo) {
        base.send(eventName: .destinationAddressSelected,
                  payload: [Keys.locationDetails: locationDetails])
    }

    func bookingRequested(quoteId: String, correlationId: String) {
        base.send(
            eventName: .checkoutBookingRequested,
            payload: [
                Keys.quoteId: quoteId,
                Keys.correlationId: correlationId
            ]
        )
    }

    func bookingSucceed(tripId: String, quoteId: String, correlationId: String) {
        base.send(
            eventName: .bookingSucceed,
            payload: [
                Keys.tripId : tripId,
                Keys.correlationId: correlationId,
                Keys.quoteId: quoteId
            ]
        )
    }

    func bookingFailure(
        quoteId: String,
        correlationId: String,
        message: String,
        lastFourDigits: String,
        paymentMethodUsed: String,
        date: Date,
        amount: String,
        currency: String
    ) {
        let dateString: String
        if #available(iOS 15.0, *) {
            dateString = date.ISO8601Format()
        } else {
            let formatter = DateFormatter()
            dateString = formatter.string(from: date)
        }
        base.send(
            eventName: .bookingFailure,
            payload: [
                Keys.quoteId: quoteId,
                Keys.correlationId: correlationId,
                Keys.errorMessage: message,
                Keys.cardLast4Digits: lastFourDigits,
                Keys.paymentMethodUsed: paymentMethodUsed,
                Keys.date: dateString,
                Keys.amount: amount,
                Keys.currency: currency
            ]
        )
    }
    func cardAuthorisationFailure(
        quoteId: String,
        errorMessage: String,
        lastFourDigits: String,
        paymentMethodUsed: String,
        date: Date,
        amount: String,
        currency: String
    ) {
        let dateString: String
        if #available(iOS 15.0, *) {
            dateString = date.ISO8601Format()
        } else {
            let formatter = DateFormatter()
            dateString = formatter.string(from: date)
        }
        base.send(
            eventName: .cardAuthorisationFailure,
            payload: [
                Keys.quoteId: quoteId,
                Keys.message: errorMessage,
                Keys.cardLast4Digits: lastFourDigits,
                Keys.paymentMethodUsed: paymentMethodUsed,
                Keys.date: dateString,
                Keys.amount: amount,
                Keys.currency: currency
            ]
        )
    }

    func cardAuthorisationSuccess(quoteId: String) {
        base.send(
            eventName: .cardAuthorisationSuccess,
            payload: [
                Keys.quoteId: quoteId,
            ]
        )
    }

    func loyaltyStatusRequested(
        quoteId: String,
        loyaltyName: String?,
        loyaltyStatus: LoyaltyStatus?,
        errorSlug: String?,
        errorMessage: String?,
        correlationId: String
    ) {
        var payload: [String : Any] = [
            Keys.correlationId: correlationId,
            Keys.quoteId: quoteId,
            Keys.loyaltyEnabled: loyaltyStatus?.canBurn == true || loyaltyStatus?.canEarn == true,
            Keys.loyaltyStatusSuccess: loyaltyStatus != nil
        ]
        if let loyaltyName = loyaltyName {
            payload[Keys.loyaltyName] = loyaltyName
        }
        if let loyaltyStatus = loyaltyStatus {
            payload[Keys.loyaltyStatusCanEarn] = loyaltyStatus.canEarn
            payload[Keys.loyaltyStatusCanBurn] = loyaltyStatus.canBurn
            payload[Keys.loyaltyStatusBalance] = loyaltyStatus.balance
        }
        if let errorSlug = errorSlug {
            payload[Keys.errorSlug] = errorSlug
        }
        if let errorMessage = errorMessage {
            payload[Keys.errorMessage] = errorMessage
        }
        base.send(
            eventName: .loyaltyStatusRequested,
            payload: payload
        )
    }

    func loyaltyPreAuthSuccess(
        quoteId: String,
        correlationId: String,
        preauthType: LoyaltyMode
    ) {
        var payload: [String : Any] = [
            Keys.quoteId: quoteId,
            Keys.correlationId: correlationId
        ]
        if let mode = getDescriptionForLoyaltyMode(preauthType) {
            payload[Keys.loyaltyPreauthType] = mode
        }
        base.send(
            eventName: .loyaltyPreauthSuccess,
            payload: payload
        )
    }

    func loyaltyPreAuthFailure(
        quoteId: String,
        correlationId: String,
        preauthType: LoyaltyMode,
        errorSlug: String?,
        errorMessage: String?
    ) {
        var payload: [String : Any] = [
            Keys.quoteId: quoteId,
            Keys.correlationId: correlationId,
        ]
        if let mode = getDescriptionForLoyaltyMode(preauthType) {
            payload[Keys.loyaltyPreauthType] = mode
        }
        if let errorSlug = errorSlug {
            payload[Keys.errorSlug] = errorSlug
        }
        if let errorMessage = errorMessage {
            payload[Keys.errorMessage] = errorMessage
        }
        
        base.send(
            eventName: .loyaltyPreauthFailure,
            payload: payload
        )
    }


    func bookingScreenOpened() {
        base.send(eventName: .bookingScreenOpened)
    }

    func checkoutOpened(_ quote: Quote) {
        base.send(
            eventName: .checkoutOpened,
            payload: [
                Keys.quoteId: quote.id
            ]
        )
    }

    func contactFleetClicked(page: AnalyticsScreen, tripDetails: TripInfo) {
        let eventName: AnalyticsConstants.EventNames
        switch page {
        case .upcomingRides:
            eventName = .ridesUpcomingContactFleetClicked
        case .vehicleTracking:
            print("this screen is not managable by this event")
            return
        }
        base.send(
            eventName: eventName,
            payload: [
                Keys.tripId: tripDetails.tripId
            ]
        )
    }

    func contactDriverClicked(page: AnalyticsScreen, tripDetails: TripInfo) {
        let eventName: AnalyticsConstants.EventNames
            switch page {
            case .upcomingRides: eventName = .ridesUpcomingContactDriverClicked
            case .vehicleTracking: eventName = .trackingContactDriverClicked
        }
        base.send(
            eventName: eventName,
            payload: [
                Keys.tripId: tripDetails.tripId
            ]
        )
    }

    func quoteListOpened(_ journeyDetails: JourneyDetails) {
        base.send(
            eventName: .quoteListOpened,
            payload: [
                Keys.bookingOriginPlaceId: journeyDetails.originLocationDetails?.placeId ?? "",
                Keys.bookingDestinationPlaceId: journeyDetails.destinationLocationDetails?.placeId ?? ""
            ]
        )
    }

    func trackTripOpened(tripDetails: TripInfo, isGuest: Bool) {
        base.send(
            eventName: .trackTripOpened,
            payload: [
                Keys.tripId: tripDetails.tripId,
                Keys.isGuest: isGuest
            ]
        )
    }

    func pastTripsOpened() {
        base.send(eventName: .ridesPastTripsOpened)
    }

    func upcomingTripsOpened() {
        base.send(eventName: .ridesUpcomingTripsOpened)
    }

    func trackTripClicked(tripDetails: TripInfo) {
        base.send(
            eventName: .ridesUpcomingTrackTripClicked,
            payload: [
                Keys.tripId: tripDetails.tripId
            ]
        )
    }
    
    private func getDescriptionForLoyaltyMode(_ type: LoyaltyMode) -> String? {

        switch type {
        case .none:
            return "none"
        case .earn:
            return "earn"
        case .burn:
            return "burn"
        case .error(_):
            return nil
        }
    }

    private struct Keys {
        static let tripState = "tripState"
        static let quoteListId = "quote_list_id"
        static let prebookTimeSet = "prebook_time_set"
        static let tripId = "trip_id"
        static let amountShown = "amountShown"
        static let timeZone = "timezone"
        static let tripInfo = "tripinfo"
        static let positionInAutocompleteList = "positioninautocompletelist"
        static let locationDetails = "locationdetails"
        static let outboundTripId = "outbound_trip_id"
        static let quoteId = "quote_id"
        static let isGuest = "is_guest"
        static let bookingOriginPlaceId = "booking_origin_place_id"
        static let bookingDestinationPlaceId = "booking_destination_place_id"
        static let message = "message"
        static let date = "date"
        static let cardLast4Digits = "card_last_4_digits"
        static let amount = "amount"
        static let currency = "currency"
        static let loyaltyEnabled = "loyaltyEnabled"
        static let paymentMethodUsed = "paymentMethodUsed"
        static let correlationId = "correlationId"
        static let loyaltyStatusSuccess = "loyalty_status_success"
        static let loyaltyStatusCanBurn = "loyalty_status_can_burn"
        static let loyaltyStatusCanEarn = "loyalty_status_can_earn"
        static let loyaltyStatusBalance = "loyalty_status_balance"
        static let errorSlug = "error_slug"
        static let errorMessage = "error_message"
        static let loyaltyName = "loyaltyName"
        static let loyaltyPreauthType = "loyalty_preauth_type"

        

    }

    struct Value {
        static let allocation = "allocation"
    }
}
