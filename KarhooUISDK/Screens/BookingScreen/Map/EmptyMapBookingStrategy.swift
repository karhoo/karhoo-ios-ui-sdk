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
    private let journeyDetailsManager: JourneyDetailsManager
    private let locationManager: CLLocationManager = CLLocationManager()
    private var reverseGeolocate: Bool = false
    private var onLocationPermissionDenied: (() -> Void)?

    init(userLocationProvider: UserLocationProvider = KarhooUserLocationProvider.shared,
         journeyDetailsManager: JourneyDetailsManager = KarhooJourneyDetailsManager.shared) {
        self.userLocationProvider = userLocationProvider
        self.journeyDetailsManager = journeyDetailsManager
    }

    func load(
        map: MapView?,
        reverseGeolocate: Bool = true,
        onLocationPermissionDenied: (() -> Void)?
    ) {
        self.mapView = map
        self.reverseGeolocate = reverseGeolocate
        self.onLocationPermissionDenied = onLocationPermissionDenied
    }

    func start(journeyDetails: JourneyDetails?) {
        mapView?.centerPin(hidden: true)
        mapView?.set(focusButtonHidden: false)

        if let userLocation = userLocationProvider.getLastKnownLocation() {
            mapView?.center(on: userLocation)
        }

        focusMap(triggerPermissionDeniedIfNeeded: false)

        userLocationProvider.set(locationChangedCallback: { [weak self] _ in
            self?.focusMap()
        })
    }

    private func focusMap(triggerPermissionDeniedIfNeeded: Bool) {
        if reverseGeolocate {
            if let location = userLocationProvider.getLastKnownLocation() {
                journeyDetailsManager.setJourneyInfo(journeyInfo: JourneyInfo(origin: location))
            } else {
                let locationAuthorizationStatus = CLLocationManager.authorizationStatus()
                switch locationAuthorizationStatus {
                case .denied, .restricted:
                    if triggerPermissionDeniedIfNeeded {
                        onLocationPermissionDenied?()
                    }
                default:
                    locationManager.requestWhenInUseAuthorization()
                }
            }
        }
    }

    func focusMap() {
        focusMap(triggerPermissionDeniedIfNeeded: true)
    }

    func changed(journeyDetails: JourneyDetails?) {}

    func stop() {
        userLocationProvider.set(locationChangedCallback: nil)
    }
}
