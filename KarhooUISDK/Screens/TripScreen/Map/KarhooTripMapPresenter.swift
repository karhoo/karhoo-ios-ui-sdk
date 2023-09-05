//
//  TripMapPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import CoreLocation
import KarhooSDK

enum TripPinTags: Int {
    case pickup = 1
    case destination = 2
    case driverLocation = 3
}

extension TripPinTags {
    var accessibilityLabel: String {
        switch self {
        case .pickup: return UITexts.Accessibility.mapPickUpPin
        case .destination: return UITexts.Accessibility.mapDropOffPin
        case .driverLocation: return UITexts.Accessibility.mapDriverPin
        }
    }
}

final class KarhooTripMapPresenter: TripMapPresenter {

    private weak var mapView: MapView?
    private weak var tripView: TripView?
    private let originAddress: TripLocationDetails
    private let destinationAddress: TripLocationDetails?
    private var previousDriverLocation: CLLocation?
    private let locationPermissionProvider: LocationPermissionProvider
    private let locationManager = CLLocationManager()

    private var onLocationPermissionDenied: (() -> Void)?

    init(
        originAddress: TripLocationDetails,
        destinationAddress: TripLocationDetails?,
        locationPermissionProvider: LocationPermissionProvider = KarhooLocationPermissionProvider()
    ) {
        self.originAddress = originAddress
        self.destinationAddress = destinationAddress
        self.locationPermissionProvider = locationPermissionProvider
    }

    func set(view: TripView?) {
        self.tripView = view
    }

    func load(map: MapView?, onLocationPermissionDenied: (() -> Void)?) {
        guard self.mapView !== map else {
            return
        }

        mapView = map
        mapView?.centerPin(hidden: true)
        mapView?.zoomToDefaultLevel()
        mapView?.set(minimumZoom: 0, maximumZoom: mapView?.idealMaximumZoom ?? 0)
        self.onLocationPermissionDenied = onLocationPermissionDenied

        let locationAuthorizationStatus = locationManager.authorizationStatus
        switch locationAuthorizationStatus {
        case .denied, .restricted:
            onLocationPermissionDenied?()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func locatePressed() {
        guard locationPermissionProvider.isLocationPermissionGranted else {
            onLocationPermissionDenied?()
            return
        }
        focusOnUserLocation()
    }
    
    func focusOnUserLocation() {
        mapView?.zoomToUserPosition { [weak self] succeeded in
            if succeeded == false {
                self?.focusOnPickupAndDriver()
            }
        }
    }
    
    func focusOnAllPOI() {
        let poi: [CLLocation] = [
            originAddress.position.toCLLocation(),
            destinationAddress?.position.toCLLocation(),
            previousDriverLocation,
            CLLocationManager().location
        ].compactMap { $0 }
        mapView?.zoom(to: poi)
    }

    func focusOnRoute() {
        guard let destination = destinationAddress else {
            focusOnPickup()
            return
        }
        mapView?.zoom(to: [originAddress.position.toCLLocation(), destination.position.toCLLocation()])
    }
    
    func focusOnPickup() {
        mapView?.zoom(to: [originAddress.position.toCLLocation()])
    }

    func focusOnPickupAndDriver() {
        guard let driverLocation = previousDriverLocation else {
            focusOnRoute()
            return
        }
        mapView?.zoom(to: [originAddress.position.toCLLocation(), driverLocation])
    }
    
    func focusOnDriver() {
        guard let driverLocation = previousDriverLocation else {
            focusOnUserLocation()
            return
        }

        mapView?.zoom(to: [driverLocation])
    }

    func updateDriver(location: CLLocation) {
        let tag = TripPinTags.driverLocation
        if previousDriverLocation == nil {
            let annotation = MapAnnotationViewModel(coordinate: location.coordinate, tag: tag)
            mapView?.addPin(annotation: annotation, tag: tag)
        } else {
            mapView?.movePin(tag: tag, to: location)
        }
        previousDriverLocation = location
    }

    func plotPins() {
        let pickUpAnnotation = MapAnnotationViewModel(coordinate: originAddress.position.toCLLocation().coordinate, tag: .pickup)
        mapView?.addPin(annotation: pickUpAnnotation,
                        tag: TripPinTags.pickup)

        guard let destination = destinationAddress else {
            return
        }

        let destAnnotation = MapAnnotationViewModel(coordinate: destination.position.toCLLocation().coordinate, tag: .destination)
        mapView?.addPin(annotation: destAnnotation,
                        tag: TripPinTags.destination)
    }
}
