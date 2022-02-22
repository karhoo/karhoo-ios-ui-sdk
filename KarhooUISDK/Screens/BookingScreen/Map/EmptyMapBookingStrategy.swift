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
    private var reverseGeolocate: Bool = false

    init(userLocationProvider: UserLocationProvider = KarhooUserLocationProvider.shared,
         bookingStatus: BookingStatus = KarhooBookingStatus.shared) {
        self.userLocationProvider = userLocationProvider
        self.bookingStatus = bookingStatus
    }

    func load(map: MapView?, reverseGeolocate: Bool = true) {
        self.mapView = map
        self.reverseGeolocate = reverseGeolocate
    }

    func start(bookingDetails: JourneyDetails?) {
        mapView?.centerPin(hidden: true)
        mapView?.set(focusButtonHidden: false)

        if let userLocation = userLocationProvider.getLastKnownLocation() {
            mapView?.center(on: userLocation)
        }

        focusMap()

        userLocationProvider.set(locationChangedCallback: { [weak self] _ in
            self?.focusMap()
        })
    }

    func focusMap() {
        if(reverseGeolocate) {
            if let location = userLocationProvider.getLastKnownLocation() {
                bookingStatus.setJourneyInfo(journeyInfo: JourneyInfo(origin: location))
            } else {
                locationManager.requestWhenInUseAuthorization()
             }
        }
    }

    func changed(bookingDetails: JourneyDetails?) {}

    func stop() {
        userLocationProvider.set(locationChangedCallback: nil)
    }
}
