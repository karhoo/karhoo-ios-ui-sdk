//
//  BookingScreenBuilder.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import CoreLocation
import Foundation
import KarhooSDK

public protocol BookingScreenBuilder {
    func buildBookingScreen(
        journeyInfo: JourneyInfo?,
        passengerDetails: PassengerDetails?,
        callback: ScreenResultCallback<BookingScreenResult>?
    ) -> Screen
}

public extension BookingScreenBuilder {
    func buildBookingScreen(
        journeyInfo: JourneyInfo? = nil,
        passengerDetails: PassengerDetails? = nil,
        callback: ScreenResultCallback<BookingScreenResult>?
    ) -> Screen {
        buildBookingScreen(journeyInfo: journeyInfo, passengerDetails: passengerDetails, callback: callback)
    }
}

public protocol BookingScreenComponents {
    /// Returns the view that serves as the address selection entry point
    /// Contains fields to display the origin and destination addresses as well as a way to select a DateTime for the ride
    func addressBar(journeyInfo: JourneyInfo?) -> AddressBarView
    
    /// Returns just the map view. When a JourneyInfo object is provided, it will display origin and/or destination pins accordingly
    func mapView(
        journeyInfo: JourneyInfo?,
        onLocationPermissionDenied: (() -> Void)?
    ) -> MapView
    
    /// Returns a screen complete with address selection, a map view with pins for origin and destination
    /// Additional functionality includes:
    /// - coverage check for selected origin
    /// - entry point to the rides list section if authenticated
    func bookingMapView(
        journeyInfo: JourneyInfo?,
        callback: ScreenResultCallback<BookingMapScreenResult>?
    ) -> Screen
    
    /// Returns a quote list screen with sorting , filtering, and address editing capabilities
    func quoteList(
        navigationController: UINavigationController,
        journeyDetails: JourneyDetails,
        onQuoteSelected: @escaping (_ quote: Quote, _ journeyDetails: JourneyDetails) -> Void
    ) -> QuoteListCoordinator
    
    /// Returns a screen with preliminary ride information and payment capabilities
    func checkout(
        navigationController: UINavigationController?,
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]?,
        callback: @escaping ScreenResultCallback<KarhooCheckoutResult>
    ) -> CheckoutCoordinator
    
    /// Returns an input form for passenger details
    /// Known issue: the return key does not automatically focus the next input field
    func passengerDetails(
        details: PassengerDetails?,
        delegate: PassengerDetailsDelegate?,
        enableBackOption: Bool
    ) -> PassengerDetailsView
    
    /// Returns a screen that allows the user to track the position of the driver as well as the status of the trip
    func followDriver(
        tripInfo: TripInfo,
        callback: @escaping ScreenResultCallback<TripScreenResult>
    ) -> Screen
}
