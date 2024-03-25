//
//  KarhooComponents.swift
//  KarhooUISDK
//
//  Created by Jeevan Thandi on 05/05/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit

public class KarhooComponents: BookingScreenComponents {

    public static let shared = KarhooComponents()

    public func addressBar(journeyInfo: JourneyInfo?) -> AddressBarView {
        let presenter = BookingAddressBarPresenter()

        let addressBarView = KarhooAddressBarView(
            cornerRadious: UIConstants.CornerRadius.large,
            borderLine: true,
            dropShadow: false,
            verticalPadding: 0,
            horizontalPadding: 0,
            hidePickUpDestinationConnector: true
        )

        addressBarView.set(presenter: presenter)
        presenter.load(view: addressBarView)

        if let journey = journeyInfo {
            KarhooJourneyDetailsManager.shared.setJourneyInfo(journeyInfo: journey)
        }

        return addressBarView
    }
    
    public func mapView(
        journeyInfo: JourneyInfo?,
        onLocationPermissionDenied: (() -> Void)?
    ) -> MapView {
        let validatedJourneyInfo = journeyInfo.validatedOrNilJourneyInfo
        KarhooJourneyDetailsManager.shared.setJourneyInfo(journeyInfo: validatedJourneyInfo)

        let mapPresenter = KarhooBookingMapPresenter()
        let mapView = KarhooMKMapView()
        mapPresenter.load(
            map: mapView,
            reverseGeolocate: validatedJourneyInfo == nil,
            onLocationPermissionDenied: onLocationPermissionDenied
        )
        mapView.set(presenter: mapPresenter)
        mapView.set(userMarkerVisible: true)
        return mapView

    }
    
    public func bookingMapView(
        journeyInfo: JourneyInfo?,
        callback: ScreenResultCallback<BookingMapScreenResult>?
    ) -> Screen {
        let presenter = KarhooBookingMapScreenPresenter(callback: callback)
        let viewController = KarhooBookingMapViewController(
            presenter: presenter,
            journeyInfo: journeyInfo
        )
        
        return viewController
    }

    public func quoteList(
        navigationController: UINavigationController,
        journeyDetails: JourneyDetails,
        onQuoteSelected: @escaping (_ quote: Quote, _ journeyDetails: JourneyDetails) -> Void
    ) -> QuoteListCoordinator {
        KarhooQuoteListCoordinator(
            navigationController: navigationController,
            journeyDetails: journeyDetails,
            onQuoteSelected: onQuoteSelected
        )
    }

    public func checkout(
        navigationController: UINavigationController?,
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]?,
        callback: @escaping ScreenResultCallback<KarhooCheckoutResult>
    ) -> CheckoutCoordinator {
        KarhooCheckoutCoordinator(
            navigationController: navigationController,
            quote: quote,
            journeyDetails: journeyDetails,
            bookingMetadata: bookingMetadata,
            callback: callback
        )
    }
    
    public func passengerDetails(
        details: PassengerDetails?,
        delegate: PassengerDetailsDelegate?,
        enableBackOption: Bool = true
    ) -> PassengerDetailsView {
        let detailsViewController = PassengerDetailsViewController()
        detailsViewController.details = details
        detailsViewController.delegate = delegate
        detailsViewController.enableBackOption = enableBackOption
        return detailsViewController
    }
    
    public func followDriver(
        tripInfo: TripInfo,
        callback: @escaping ScreenResultCallback<TripScreenResult>
    ) -> Screen {
        UISDKScreenRouting.default.tripScreen().buildTripScreen(trip: tripInfo, callback: callback)
    }
}
