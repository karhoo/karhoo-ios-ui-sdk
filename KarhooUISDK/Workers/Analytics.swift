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
    func appOpened()
    func appBackgrounded()
    func appClosed()
    func vehicleTypeSelected(selectedCategory: String,
                             quoteListId: String?)
    func changePaymentPressed()
    func availabilityListExpanded()
    func locationServicesRejected()
    func prebookOpened()
    func tripStateChanged(to newState: String)
    func fleetsSorted(by sortType: String)
    func fleetListShown(quoteListId: String?)
    func prebookPickerOpened()
    func prebookTimeSet(date: Date)
    func userCalledDriver()
    func userTermsReviewed()
    func userCardRegistered()
    func cardRegistrationFailed()
    func pickupAddressDisplayed(count: Int)
    func destinationAddressDisplayed(count: Int)
    func pickupAddressSelected(_: LocationInfo)
    func destinationAddressSelected(_: LocationInfo)
    func returnRideRequested()
    func rideSummaryExited()
    func tripAllocationCancellationIntiatedByUser(trip: TripInfo)
    func userPressedCurrentLocation(addressType: String)
    func bookingRequested(destination: LocationInfo,
                          dateScheduled: Date?,
                          quote: Quote)
    
    func bookingScreenOpened()
    func quoteListOpened(_ bookingDetails: BookingDetails)
    func checkoutOpened(_ quote: Quote)
    func bookingRequested(tripDetails: TripInfo, outboundTripId: String?)
    func paymentSucceed()
    func paymentFailed()
    func trackTripOpened(tripDetails: TripInfo, isGuest: Bool)
    func pastTripsOpened()
    func upcomingTripsOpened()
    func trackTripClicked(tripDetails: TripInfo)
    func contactFleetClicked(page: AnalyticsScreen, tripDetails: TripInfo)
    func contactDriverClicked(page: AnalyticsScreen, tripDetails: TripInfo)
}

public enum AnalyticsScreen {
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

    func changePaymentPressed() {
        base.send(eventName: .changePaymentDetailsPressed)
    }

    func appOpened() {
        base.send(eventName: .appOpened, payload: emptyPayload)
    }

    func appBackgrounded() {
        base.send(eventName: .appBackgrounded, payload: emptyPayload)
    }

    func appClosed() {
        base.send(eventName: .appClosed, payload: emptyPayload)
    }

    func availabilityListExpanded() {
        base.send(eventName: .availabilityListExpanded, payload: emptyPayload)
    }

    func bookingScreenOpened() {
        base.send(eventName: .bookingScreenOpened)
    }

    func bookingRequested(tripDetails: TripInfo, outboundTripId: String?) {
        base.send(
            eventName: .checkoutBookingRequested,
            payload: [
                Keys.tripId: tripDetails.tripId,
                Keys.outboundTripId: outboundTripId ?? ""
            ]
        )
    }

    func bookingRequested(destination: LocationInfo,
                          dateScheduled: Date?,
                          quote: Quote) {
        let payload: [String: Any] = [AnalyticsConstants.Keys.price.rawValue: quote.price.highPrice,
                                      AnalyticsConstants.Keys.priceCurrency.rawValue: quote.price.currencyCode,
                                      AnalyticsConstants.Keys.destinationLatitude.rawValue:
                                        destination.position.latitude,
                                      AnalyticsConstants.Keys.destinationLongitude.rawValue:
                                        destination.position.longitude,
                                      AnalyticsConstants.Keys.destinationAddress.rawValue:
                                        destination.address.displayAddress,
                                      AnalyticsConstants.Keys.isPrebook.rawValue: dateScheduled != nil]

        base.send(eventName: .bookingRequested, payload: payload)
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
        case .upcomingRides: eventName = .contactFleetClicked
        case .vehicleTracking: fatalError("this screen is not managable by this event")
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

    func locationServicesRejected() {
        base.send(eventName: .locationServicesRejected, payload: emptyPayload)
    }

    func prebookOpened() {
        base.send(eventName: .prebookOpened, payload: emptyPayload)
    }

    func tripStateChanged(to newState: String) {
        base.send(eventName: .stateChangeDisplayed,
                  payload: [Keys.tripState: newState])
    }

    func fleetsSorted(by sortType: String) {
        base.send(eventName: .fleetListSorted, payload: [Keys.sortType: sortType])
    }

    func fleetListShown(quoteListId: String?) {
        base.send(eventName: .fleetListShown, payload: [
            Keys.quoteListId: quoteListId ?? ""
        ])
    }

    func prebookTimeSet(date: Date) {
        let timestamp = timestampFormatter.formattedDate(date)
        base.send(eventName: .prebookTimeSet, payload: [Keys.prebookTimeSet: timestamp])
    }

    func prebookPickerOpened() {
        base.send(eventName: .prebookOpened, payload: emptyPayload)
    }

    func userCalledDriver() {
        base.send(eventName: .userCalledDriver, payload: emptyPayload)
    }

    func userTermsReviewed() {
        base.send(eventName: .userTermsReviewed, payload: emptyPayload)
    }

    func userCardRegistered() {
        base.send(eventName: .userCardRegistered, payload: emptyPayload)
    }

    func cardRegistrationFailed() {
        base.send(eventName: .userCardRegistrationFailed, payload: emptyPayload)
    }

    func pickupAddressDisplayed(count: Int) {
        base.send(eventName: .pickupAddressDisplayed, payload: [Keys.countAddressOptions: count])
    }

    func destinationAddressDisplayed(count: Int) {
        base.send(eventName: .destinationAddressDisplayed, payload: [Keys.countAddressOptions: count])
    }

    func pickupAddressSelected(_ locationDetails: LocationInfo) {
        base.send(eventName: .pickupAddressSelected,
                  payload: [Keys.address: locationDetails.address.displayAddress])
    }

    func paymentSucceed() {
        base.send(eventName: .paymentSucceed)
    }

    func paymentFailed() {
        base.send(eventName: .paymentFailed)
    }

    func destinationAddressSelected(_ locationDetails: LocationInfo) {
        base.send(eventName: .destinationAddressSelected,
                  payload: [Keys.address: locationDetails.address.displayAddress])
    }

    func returnRideRequested() {
        base.send(eventName: .returnRideRequested, payload: emptyPayload)
    }

    func rideSummaryExited() {
        base.send(eventName: .rideSummaryExited, payload: emptyPayload)
    }

    func tripAllocationCancellationIntiatedByUser(trip: TripInfo) {
          base.send(eventName: .tripCancellationInitiatedByUser,
                    payload: [Keys.screen: Value.allocation,
                              Keys.tripId: trip.tripId])
    }
    
    func userPressedCurrentLocation(addressType: String) {
        base.send(eventName: .currentLocationPressed, payload: [Keys.address: addressType])
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
        base.send(eventName: .pastTripsOpened)
    }

    func upcomingTripsOpened() {
        base.send(eventName: .upcomingTripsOpened)
    }

    func trackTripClicked(tripDetails: TripInfo) {
        base.send(
            eventName: .trackTripClicked,
            payload: [
                Keys.tripId: tripDetails.tripId
            ]
        )
    }

    func vehicleTypeSelected(selectedCategory: String, quoteListId: String?) {
        base.send(eventName: .categorySelected,
                  payload: [
                    Keys.categorySelected: selectedCategory,
                    Keys.quoteListId: quoteListId ?? ""
        ])
    }

    struct Keys {
        static let categorySelected = "category"
        static let tripState = "tripState"
        static let sortType = "sortType"
        static let qtaListId = "qta_list_id"
        static let quoteListId = "quote_list_id"
        static let prebookTimeSet = "prebook_time_set"
        static let etaDisplayed = "etaDisplayed"
        static let detaDisplayed = "detaDisplayed"
        static let countAddressOptions = "countAddressOptions"
        static let address = "address"
        static let addressType = "addressType"
        static let screen = "screen"
        static let tripId = "trip_id"
        static let outboundTripId = "outbound_trip_id"
        static let quoteId = "quote_id"
        static let isGuest = "is_guest"
        static let bookingOriginPlaceId = "booking_origin_place_id"
        static let bookingDestinationPlaceId = "booking_destination_place_id"
    }

    struct Value {
        static let allocation = "allocation"
    }
}
