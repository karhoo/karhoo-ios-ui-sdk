//
//  PickupOnlyStrategy.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK
import CoreLocation

protocol PickupOnlyStrategyDelegate: class {
    func setFromMap(pickup: LocationInfo?)
    func pickupFailedToSetFromMap(error: KarhooError?)
}

protocol PickupOnlyStrategyProtocol: BookingMapStrategy {
    func set(delegate: PickupOnlyStrategyDelegate?)
}

final class PickupOnlyStrategy: PickupOnlyStrategyProtocol, BookingMapStrategy, MapViewActions {

    private weak var map: MapView?

    private let userLocationProvider: UserLocationProvider
    private let addressService: AddressService
    weak var delegate: PickupOnlyStrategyDelegate?
    private var timer: TimeScheduler?
    private var currentPickup: LocationInfo?
    private var lastLocation: CLLocation?
    private let bookingStatus: BookingStatus

    init(userLocationProvider: UserLocationProvider = KarhooUserLocationProvider.shared,
         addressService: AddressService = Karhoo.getAddressService(),
         timer: TimeScheduler = KarhooTimeScheduler(),
         bookingStatus: BookingStatus = KarhooBookingStatus.shared) {
        self.userLocationProvider = userLocationProvider
        self.addressService = addressService
        self.timer = timer
        self.bookingStatus = bookingStatus
    }

    func set(delegate: PickupOnlyStrategyDelegate?) {
        self.delegate = delegate
    }

    func load(map: MapView?) {
        self.map = map
        self.map?.set(actions: self)
        self.map?.set(userMarkerVisible: true)
    }

    func start(bookingDetails: BookingDetails?) {
        setup(bookingDetails: bookingDetails)
        userLocationProvider.set(locationChangedCallback: { [weak self] (location: CLLocation) in
            self?.didGetUserLocation(location)
        })
    }

    private func setup(bookingDetails: BookingDetails?) {
        guard bookingDetails?.destinationLocationDetails == nil else {
            stop()
            return
        }

        guard let pickup = bookingDetails?.originLocationDetails else {
            return
        }

        map?.set(actions: self)
        map?.removePin(tag: BookingPinTags.pickup.rawValue)
        map?.set(focusButtonHidden: false)

        let pickupPosition = pickup.position.toCLLocation()

        map?.centerPin(hidden: false)
        map?.center(on: pickupPosition)
        
    }

    func focusMap() {

        func focousOnPickup() {
            if let originPosition = bookingStatus.getBookingDetails()?.originLocationDetails?.position {
                map?.center(on: originPosition.toCLLocation())
                return
            }
        }

        func focusOnCurrentLocation() {
            if let currentLocation = userLocationProvider.getLastKnownLocation() {
                map?.center(on: currentLocation, zoomLevel: map?.standardZoom ?? 0)
                reverseGeoLocate(location: currentLocation)
            } else {
                focousOnPickup()
            }
        }

        focusOnCurrentLocation()
      
    }

    func changed(bookingDetails: BookingDetails?) {
        setup(bookingDetails: bookingDetails)
    }

    func stop() {
        map?.set(actions: nil)
        map?.centerPin(hidden: true)
        currentPickup = nil
    }

    func userStartedMovingTheMap() {
        guard shouldReverseGeolocateOnMapDrag() else {
            return
        }

        timer?.invalidate()
    }

    func userStoppedMovingTheMap(center: CLLocation?) {
        guard shouldReverseGeolocateOnMapDrag() else {
            return
        }

        timer?.schedule(block: { [weak self] in
            self?.reverseGeoLocate(location: center)
            }, in: 0.5,
           repeats: false)
    }

    private func didGetUserLocation(_ location: CLLocation) {
        reverseGeoLocate(location: location)
        userLocationProvider.set(locationChangedCallback: nil)
        map?.center(on: location, zoomLevel: map?.standardZoom ?? 0)
        return
    }

    private func shouldReverseGeolocateOnMapDrag() -> Bool {
        return true
    }

    private func reverseGeoLocate(location: CLLocation?) {
        guard let location = location else {
             return
        }

        lastLocation = location
        addressService.reverseGeocode(position: location.toPosition()).execute(callback: { [weak self] result in
            if let address = result.successValue() {
                self?.reverseGeolocateSuccess(details: address, for: location)
            } else {
                self?.delegate?.pickupFailedToSetFromMap(error: result.errorValue())
            }
        })
    }

    private func reverseGeolocateSuccess(details: LocationInfo, for location: CLLocation) {
        guard lastLocation == location else {
            return
        }
        currentPickup = details

        delegate?.setFromMap(pickup: details)
    }
}
