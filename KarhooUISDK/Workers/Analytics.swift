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
    
    func bookingRequested(tripDetails: TripInfo, outboundTripId: String?)
    func paymentSucceed(tripDetails: TripInfo)
    func paymentFailed(tripDetails: TripInfo, message: String, last4Digits: String, date: Date, amount: String, currency: String)
    func cardAuthorisationFail(message: String, last4Digits: String, date: Date, amount: String, currency: String)
    func cardAuthorisationSuccess(tripDetails: TripInfo)
    func loyaltyStatusRequested(tripDetails: TripInfo, loyaltyEnabled: Bool, result: (canEarn: Bool, canBurn: Bool, balance: Int)?)
    func loyaltyPreAuthFail(tripDetails: TripInfo)
    func loyaltyPreAuthSuccess(tripDetails: TripInfo)
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

    func bookingRequested(tripDetails: TripInfo, outboundTripId: String?) {
        var payload =  [
            Keys.tripId: tripDetails.tripId
        ]
        if let outboundTripId = outboundTripId {
            payload[Keys.outboundTripId] = outboundTripId
        }
        base.send(
            eventName: .checkoutBookingRequested,
            payload: payload
        )
    }

    func paymentSucceed(tripDetails: TripInfo) {
        base.send(
            eventName: .paymentSucceed,
            payload: [Keys.tripId : tripDetails.tripId]
            )
    }

    func paymentFailed(
            tripDetails: TripInfo,
            message: String,
            last4Digits: String,
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
                eventName: .paymentFailed,
                payload: [
                    Keys.tripId: tripDetails.tripId,
                    Keys.message: message,
                    Keys.cardLast4Digits: last4Digits,
                    Keys.date: dateString,
                    Keys.amount: amount,
                    Keys.currency: currency
                ]
        )
    }

    func cardAuthorisationFail(
        tripDetails: TripInfo,
        message: String,
        last4Digits: String,
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
            eventName: .cardAuthorisationFailed,
            payload: [
                Keys.tripId: tripDetails.tripId,
                Keys.message: message,
                Keys.cardLast4Digits: last4Digits,
                Keys.date: dateString,
                Keys.amount: amount,
                Keys.currency: currency
            ]
        )
    }

    func cardAuthorisationSuccess(
        tripDetails: TripInfo
    ) {
        base.send(
            eventName: .cardAuthorisationSuccess,
            payload: [
                Keys.tripId: tripDetails.tripId,
            ]
        )
    }

    func loyaltyStatusRequested(
        tripDetails: TripInfo,
        loyaltyEnabled: Bool,
        result: (canEarn: Bool,
                 canBurn: Bool,
                 balance: Int)?
    ) {
        var payload: [String : Any] = [
            Keys.tripId: tripDetails.tripId,
            Keys.loyaltyEnabled: loyaltyEnabled
        ]
        if let result = result {
            payload["canEarn"] = result.canEarn
            payload["canBurn"] = result.canBurn
            payload["balance"] = result.balance
        }
        base.send(
            eventName: .loyaltyStatusRequested,
            payload: payload
        )
    }

    func loyaltyPreAuthSuccess(tripDetails: TripInfo) {
        base.send(
            eventName: .loyaltyPreauthSuccess,
            payload: [
                Keys.tripId: tripDetails.tripId,
            ]
        )
    }

    func loyaltyPreAuthFail(
        tripDetails: TripInfo
    ) {
        base.send(
            eventName: .loyaltyPreauthFailed,
            payload: [
                Keys.tripId: tripDetails.tripId,
            ]
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
        static let canEarn = "canEarn"
        static let canBurn = "canBurn"
        static let balance = "balance"
    }

    struct Value {
        static let allocation = "allocation"
    }
}
