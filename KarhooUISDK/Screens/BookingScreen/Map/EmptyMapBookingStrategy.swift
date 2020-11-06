//
//  EmptyBookingStrategy.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK
import CoreLocation

final class EmptyMapBookingStrategy: BookingMapStrategy {

    private let userLocationProvider: UserLocationProvider
    private var mapView: MapView?
    private let bookingStatus: BookingStatus
    private let locationManager: CLLocationManager = CLLocationManager()

    init(userLocationProvider: UserLocationProvider = KarhooUserLocationProvider.shared,
         bookingStatus: BookingStatus = KarhooBookingStatus.shared) {
        self.userLocationProvider = userLocationProvider
        self.bookingStatus = bookingStatus
    }

    func load(map: MapView?) {
        self.mapView = map
    }

    func start(bookingDetails: BookingDetails?) {
        mapView?.centerPin(hidden: true)
        mapView?.set(focusButtonHidden: Karhoo.configuration.authenticationMethod().isGuest())

        if let userLocation = userLocationProvider.getLastKnownLocation() {
            mapView?.center(on: userLocation)
        }

        focusMap()

        userLocationProvider.set(locationChangedCallback: { [weak self] _ in
            self?.focusMap()
        })
    }

    func focusMap() {
        guard Karhoo.configuration.authenticationMethod().isGuest() == false else {
            return
        }

        if let location = userLocationProvider.getLastKnownLocation() {
            bookingStatus.setJourneyInfo(journeyInfo: JourneyInfo(origin: location))
        } else {
            locationManager.requestWhenInUseAuthorization()
         }
    }

    func changed(bookingDetails: BookingDetails?) {}

    func stop() {
        userLocationProvider.set(locationChangedCallback: nil)
    }
}
