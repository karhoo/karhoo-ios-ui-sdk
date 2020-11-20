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
    private let pickupPinTag: Int
    private var currentPickupAddress: LocationInfo?
    private let destinationPinTag: Int
    private var currentDestinationAddress: LocationInfo?

    init(pickupPinTag: Int = BookingPinTags.pickup.rawValue,
         destinationPinTag: Int = BookingPinTags.destination.rawValue) {
        self.pickupPinTag = pickupPinTag
        self.destinationPinTag = destinationPinTag
    }

    func load(map: MapView?) {
        self.map = map
    }

    func start(bookingDetails: BookingDetails?) {
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

    func changed(bookingDetails: BookingDetails?) {
        handle(bookingDetails: bookingDetails)
    }

    func stop() {
        currentPickupAddress = nil
        currentDestinationAddress = nil
        removePins()
    }

    private func handle(bookingDetails: BookingDetails?) {
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
        map?.removePin(tag: pickupPinTag)
        map?.addPin(location: pickup.position.toCLLocation(), asset: PinAsset.pickup, tag: pickupPinTag)

        currentPickupAddress = pickup
    }

    private func isChanged(destination: LocationInfo) -> Bool {
        return destination.placeId != currentDestinationAddress?.placeId
    }

    private func setNew(destination: LocationInfo) {
        if currentDestinationAddress == nil {
            map?.addPin(location: destination.position.toCLLocation(),
                        asset: PinAsset.destination,
                        tag: destinationPinTag)
        } else {
            map?.removePin(tag: destinationPinTag)
            map?.addPin(location: destination.position.toCLLocation(),
                        asset: PinAsset.destination,
                        tag: destinationPinTag)
        }
        currentDestinationAddress = destination
    }

    private func removePins() {
        map?.removePin(tag: pickupPinTag)
        map?.removePin(tag: destinationPinTag)
        map?.removeTripLine()
    }
}
