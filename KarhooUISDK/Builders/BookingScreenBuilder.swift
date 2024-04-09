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
import UIKit

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
    
    /// Returns the view that serves as the address selection entry point
    /// Contains fields to display the origin and destination addresses as well as a way to select a DateTime for the ride
    /// Set 'hidePrebook' as false to limit the user option to asap rides only
    func addressBar(journeyInfo: JourneyInfo?, hidePrebook: Bool) -> AddressBarView
    
    /// Returns just the map view. When a JourneyInfo object is provided, it will display origin and/or destination pins accordingly
    func mapView(
        journeyInfo: JourneyInfo?,
        reverseGeolocate: Bool?,
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
    
    /// Returns an overlay with a spinner and a cancel button that monitors the trip allocation status
    /// Implement the TripAllocationActions methods to handle allocation success / failure / cancellation
    /// Use allocationView.presentScreen(forTrip: TripInfo) to modally present the allocation view
    func allocationView(delegate: TripAllocationActions) -> TripAllocationView
}
