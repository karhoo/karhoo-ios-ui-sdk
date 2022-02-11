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

    func bookingRequested(tripDetails: TripInfo, outboundTripId: String?) {
        base.send(
            eventName: .checkoutBookingRequested,
            payload: [
                Keys.tripId: tripDetails.tripId,
                Keys.outboundTripId: outboundTripId ?? ""
            ]
        )
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
        case .upcomingRides: eventName = .ridesUpcomingContactFleetClicked
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
    
    func destinationAddressSelected(locationDetails: LocationInfo){
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

    func vehicleTypeSelected(selectedCategory: String, quoteListId: String?) {
        base.send(eventName: .categorySelected,
                  payload: [
                    Keys.categorySelected: selectedCategory,
                    Keys.quoteListId: quoteListId ?? ""
        ])
    }

    func paymentSucceed() {
        base.send(eventName: .paymentSucceed)
    }

    func paymentFailed() {
        base.send(eventName: .paymentFailed)
    }

    struct Keys {
        static let tripState = "tripState"
        static let quoteListId = "quote_list_id"
        static let prebookTimeSet = "prebook_time_set"
        static let amountShown = "amountShown"
        static let timeZone = "timezone"
        static let tripInfo = "tripinfo"
        static let positionInAutocompleteList = "positioninautocompletelist"
        static let locationDetails = "locationdetails"
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
