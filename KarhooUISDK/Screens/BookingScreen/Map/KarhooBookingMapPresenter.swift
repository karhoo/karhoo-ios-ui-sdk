//
//  KarhooBookingMapPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import CoreLocation
import KarhooSDK

final class KarhooBookingMapPresenter: BookingMapPresenter {

    private let pickupOnlyStrategy: BookingMapStrategy
    private let destinationSetStrategy: BookingMapStrategy
    private let emptyBookingStrategy: BookingMapStrategy
    private var currentStrategy: BookingMapStrategy?
    private let journeyDetailsManager: JourneyDetailsManager

    private var onLocationPermissionDenied: (() -> Void)?

    init(pickupOnlyStrategy: PickupOnlyStrategyProtocol = PickupOnlyStrategy(),
         destinationSetStrategy: BookingMapStrategy = DestinationSetStrategy(),
         journeyDetailsManager: JourneyDetailsManager =  KarhooJourneyDetailsManager.shared,
         emptyBookingStrategy: BookingMapStrategy = EmptyMapBookingStrategy()
    ) {
        self.pickupOnlyStrategy = pickupOnlyStrategy
        self.destinationSetStrategy = destinationSetStrategy
        self.journeyDetailsManager = journeyDetailsManager
        self.emptyBookingStrategy = emptyBookingStrategy
        pickupOnlyStrategy.set(delegate: self)
        journeyDetailsManager.add(observer: self)
        currentStrategy = getStrategyToUse(details: journeyDetailsManager.getJourneyDetails())
    }

    deinit {
        journeyDetailsManager.remove(observer: self)
    }
    
    func load(
        map: MapView?,
        reverseGeolocate: Bool = true,
        onLocationPermissionDenied: (() -> Void)?) {
            self.onLocationPermissionDenied = onLocationPermissionDenied
            [pickupOnlyStrategy, destinationSetStrategy, emptyBookingStrategy].forEach { strategy in
                strategy.load(
                    map: map,
                    reverseGeolocate: reverseGeolocate,
                    onLocationPermissionDenied: onLocationPermissionDenied
                )
            }
            
            currentStrategy?.start(journeyDetails: journeyDetailsManager.getJourneyDetails())
        }

    func focusMap() {
        let isLocationPermissionGranted = CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways
        guard isLocationPermissionGranted else {
            onLocationPermissionDenied?()
            return
        }
        currentStrategy?.focusMap()
    }

    private func getStrategyToUse(details: JourneyDetails?) -> BookingMapStrategy {
        if details?.originLocationDetails == nil && details?.destinationLocationDetails == nil {
            return emptyBookingStrategy
        } else if details?.originLocationDetails != nil && details?.destinationLocationDetails == nil {
            return pickupOnlyStrategy
        } else {
            return destinationSetStrategy
        }
    }

    private func changeTo(strategy: BookingMapStrategy, details: JourneyDetails?) {
        currentStrategy?.stop()
        currentStrategy = strategy
        currentStrategy?.start(journeyDetails: details)
    }
}

extension KarhooBookingMapPresenter: PickupOnlyStrategyDelegate {

    func setFromMap(pickup: LocationInfo?) {
        journeyDetailsManager.set(pickup: pickup)
    }

    func pickupFailedToSetFromMap(error: KarhooError?) {
        print("pickup failed: error: \(String(describing: error?.message))")
    }
}

extension KarhooBookingMapPresenter: JourneyDetailsObserver {

    func journeyDetailsChanged(details: JourneyDetails?) {
        let strategyToUse = getStrategyToUse(details: details)

        if strategyToUse !== currentStrategy {
            changeTo(strategy: strategyToUse, details: details)
        } else {
            currentStrategy?.changed(journeyDetails: details)
        }
    }
}
