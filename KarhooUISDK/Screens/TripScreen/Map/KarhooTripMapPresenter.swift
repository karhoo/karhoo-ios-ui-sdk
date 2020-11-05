//
//  TripMapPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import CoreLocation
import KarhooSDK

private enum TripPinTags: Int {
    case pickup = 1
    case destination = 2
    case driverLocation = 3
}

final class KarhooTripMapPresenter: TripMapPresenter {

    private weak var mapView: MapView?
    private weak var tripView: TripView?
    private let originAddress: TripLocationDetails
    private let destinationAddress: TripLocationDetails?
    private var previousDriverLocation: CLLocation?

    init(originAddress: TripLocationDetails,
         destinationAddress: TripLocationDetails?) {
        self.originAddress = originAddress
        self.destinationAddress = destinationAddress
    }

    func set(view: TripView?) {
        self.tripView = view
    }

    func load(map: MapView?) {
        guard self.mapView !== map else {
            return
        }

        mapView = map
        mapView?.centerPin(hidden: true)
        mapView?.zoomToDefaultLevel()
        mapView?.set(minimumZoom: 0, maximumZoom: mapView?.idealMaximumZoom ?? 0)
    }

    func focusOnRoute() {
        guard let destination = destinationAddress else {
            mapView?.zoom(to: [originAddress.position.toCLLocation()])
            return
        }

        mapView?.zoom(to: [originAddress.position.toCLLocation(), destination.position.toCLLocation()])
    }

    func focusOnPickupAndDriver() {
        guard let driverLocation = previousDriverLocation else {
            focusOnRoute()
            return
        }
        mapView?.zoom(to: [originAddress.position.toCLLocation(), driverLocation])
    }

    func focusOnDestinationAndDriver() {
        guard let driverLocation = previousDriverLocation,
              let destinationLocation = destinationAddress?.position.toCLLocation() else {
                focusOnRoute()
            return
        }

        mapView?.zoom(to: [destinationLocation, driverLocation])
    }

    func updateDriver(location: CLLocation) {
        let tag = TripPinTags.driverLocation.rawValue
        if previousDriverLocation == nil {
            mapView?.addPin(location: location, asset: "car_icon", tag: tag)
        } else {
            mapView?.movePin(tag: tag, to: location)
        }
        previousDriverLocation = location
    }

    func plotPins() {
        mapView?.addPin(location: originAddress.position.toCLLocation(),
                        asset: "pickup_pin",
                        tag: TripPinTags.pickup.rawValue)

        guard let destination = destinationAddress else {
            return
        }

        mapView?.addPin(location: destination.position.toCLLocation(),
                        asset: "dropoff_pin",
                        tag: TripPinTags.destination.rawValue)
    }
}
