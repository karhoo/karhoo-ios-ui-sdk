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
    private let locationService: LocationService
    private var reverseGeolocate: Bool

    init(userLocationProvider: UserLocationProvider = KarhooUserLocationProvider.shared,
         addressService: AddressService = Karhoo.getAddressService(),
         timer: TimeScheduler = KarhooTimeScheduler(),
         bookingStatus: BookingStatus = KarhooBookingStatus.shared,
         locationService: LocationService = KarhooLocationService()) {
        self.userLocationProvider = userLocationProvider
        self.addressService = addressService
        self.timer = timer
        self.bookingStatus = bookingStatus
        self.locationService = locationService
        self.reverseGeolocate = false
    }

    func set(delegate: PickupOnlyStrategyDelegate?) {
        self.delegate = delegate
    }

    func load(map: MapView?, reverseGeolocate: Bool = true) {
        self.map = map
        self.map?.set(actions: self)
        self.map?.set(userMarkerVisible: true)
        self.reverseGeolocate = reverseGeolocate
    }

    func start(journeyDetails: JourneyDetails?) {
        setup(journeyDetails: journeyDetails)
        userLocationProvider.set(locationChangedCallback: { [weak self] (location: CLLocation) in
            self?.didGetUserLocation(location)
        })
    }

    private func setup(journeyDetails: JourneyDetails?) {
        guard journeyDetails?.destinationLocationDetails == nil else {
            stop()
            return
        }

        guard let pickup = journeyDetails?.originLocationDetails else {
            return
        }

        map?.set(actions: self)
        map?.removePin(tag: TripPinTags.pickup)
        map?.set(focusButtonHidden: false)

        let pickupPosition = pickup.position.toCLLocation()

        if locationService.locationAccessEnabled() {
            map?.centerPin(hidden: false)
        } else {
            map?.centerPin(hidden: true)
            let annotation = MapAnnotationViewModel(coordinate: pickupPosition.coordinate, tag: .pickup)
            map?.addPin(annotation: annotation, tag: TripPinTags.pickup)
        }
        
        map?.center(on: pickupPosition)
    }

    func focusMap() {

        func focousOnPickup() {
            if let originPosition = bookingStatus.getJourneyDetails()?.originLocationDetails?.position {
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

    func changed(journeyDetails: JourneyDetails?) {
        setup(journeyDetails: journeyDetails)
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
        if(reverseGeolocate) {
            reverseGeoLocate(location: location)
            userLocationProvider.set(locationChangedCallback: nil)
            map?.center(on: location, zoomLevel: map?.standardZoom ?? 0)
        }
    }

    private func shouldReverseGeolocateOnMapDrag() -> Bool {
        return locationService.locationAccessEnabled()
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
