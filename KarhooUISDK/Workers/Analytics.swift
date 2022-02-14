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
    
    func bookingRequested(tripDetails: TripInfo) // runtime-ok  KarhooCheckoutPresenter  testWhenBookingIsAboutToBeRequestedProperAnalyticsEventIsTriggered
    func paymentSucceed() // runtime-X KarhooCheckoutPresenter testWhenPaymentSuccededProperAnalyticsEventIsTriggered
    func paymentFailed(_ message: String) // runtime-X KarhooCheckoutPresenter
    func trackTripOpened(tripDetails: TripInfo, isGuest: Bool) // runtime-ok  KarhooTripPresenter
    func pastTripsOpened() // runtime-ok  KarhooRidesPresenter
    func upcomingTripsOpened() // runtime-ok  KarhooRidesPresenter
    func trackTripClicked(tripDetails: TripInfo) // runtime-ok KarhooRidesPresenter
    func contactFleetClicked(page: AnalyticsScreen, tripDetails: TripInfo) // runtime-ok-upcoming KarhooRidesPresenter
    func contactDriverClicked(page: AnalyticsScreen, tripDetails: TripInfo) // runtime-X KarhooRidesPresenter; some other presetner with TRACK feature
    func bookingScreenOpened() // runtime-ok KarhooBookingPresenter
    func checkoutOpened(_ quote: Quote) // runtime-ok KarhooCheckoutPresenter // testWhenCheckoutOpensProperAnalyticsEventIsTriggered
    func quoteListOpened(_ bookingDetails: BookingDetails)  // runtime-ok KarhooQuoteListPresenter
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

    func bookingRequested(tripDetails: TripInfo) {
        base.send(
            eventName: .checkoutBookingRequested,
            payload: [
                Keys.tripId: tripDetails.tripId
            ]
        )
    }

    func paymentSucceed() {
        base.send(eventName: .paymentSucceed)
    }

    func paymentFailed(_ message: String) {
        base.send(
            eventName: .paymentFailed,
            payload: [
                Keys.message: message
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

    func quoteListOpened(_ bookingDetails: BookingDetails) {
        base.send(
            eventName: .quoteListOpened,
            payload: [
                Keys.bookingOriginPlaceId: bookingDetails.originLocationDetails?.placeId ?? "",
                Keys.bookingDestinationPlaceId: bookingDetails.destinationLocationDetails?.placeId ?? ""
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
    }

    struct Value {
        static let allocation = "allocation"
    }
}
