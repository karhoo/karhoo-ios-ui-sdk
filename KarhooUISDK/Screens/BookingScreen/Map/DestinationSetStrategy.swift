//
//  DestinationSetStrategy.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import CoreLocation
import KarhooSDK

final class DestinationSetStrategy: BookingMapStrategy {

    private var map: MapView?
    private var currentPickupAddress: LocationInfo?
    private var currentDestinationAddress: LocationInfo?
    
    func load(map: MapView?, reverseGeolocate: Bool = true) {
        self.map = map
    }

    func start(bookingDetails: JourneyDetails?) {
        handle(bookingDetails: bookingDetails)
    }

    func focusMap() {
        guard let pickup = currentPickupAddress?.position.toCLLocation() else {
            return
        }

        guard let destination = currentDestinationAddress?.position.toCLLocation() else {
            return
        }

        map?.zoom(to: [pickup, destination])
    }

    func changed(bookingDetails: JourneyDetails?) {
        handle(bookingDetails: bookingDetails)
    }

    func stop() {
        currentPickupAddress = nil
        currentDestinationAddress = nil
        removePins()
    }

    private func handle(bookingDetails: JourneyDetails?) {
        guard let pickup = bookingDetails?.originLocationDetails else {
            return
        }

        guard let destination = bookingDetails?.destinationLocationDetails else {
            return
        }

        let pickupChanged = isChanged(pickup: pickup)
        if pickupChanged {
            setNew(pickup: pickup)
        }

        let destinationChanged = isChanged(destination: destination)
        if destinationChanged {
            setNew(destination: destination)
        }

        map?.addTripLine(pickup: pickup.position.toCLLocation(),
                            dropoff: destination.position.toCLLocation())

        if pickupChanged || destinationChanged {
            map?.zoom(to: [pickup.position.toCLLocation(), destination.position.toCLLocation()])
        }
    }

    private func isChanged(pickup: LocationInfo) -> Bool {
        return pickup.placeId != currentPickupAddress?.placeId
    }

    private func setNew(pickup: LocationInfo) {
        map?.removePin(tag: TripPinTags.pickup)
        let annotation = MapAnnotationViewModel(coordinate: pickup.position.toCLLocation().coordinate, tag: .pickup)
        map?.addPin(annotation: annotation, tag: TripPinTags.pickup)

        currentPickupAddress = pickup
    }

    private func isChanged(destination: LocationInfo) -> Bool {
        return destination.placeId != currentDestinationAddress?.placeId
    }

    private func setNew(destination: LocationInfo) {
        if currentDestinationAddress != nil {
            map?.removePin(tag: TripPinTags.destination)
        }
        let annotation = MapAnnotationViewModel(coordinate: destination.position.toCLLocation().coordinate, tag: .destination)
        map?.addPin(annotation: annotation,
                    tag: TripPinTags.destination)
        currentDestinationAddress = destination
    }

    private func removePins() {
        map?.removePin(tag: TripPinTags.pickup)
        map?.removePin(tag: TripPinTags.destination)
        map?.removeTripLine()
    }
}
