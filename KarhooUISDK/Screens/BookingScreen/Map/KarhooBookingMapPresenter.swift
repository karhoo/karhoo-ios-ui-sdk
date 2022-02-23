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
    private let journeyDetailsController: JourneyDetailsController

    init(pickupOnlyStrategy: PickupOnlyStrategyProtocol = PickupOnlyStrategy(),
         destinationSetStrategy: BookingMapStrategy = DestinationSetStrategy(),
         journeyDetailsController: JourneyDetailsController =  KarhooJourneyDetailsController.shared,
         emptyBookingStrategy: BookingMapStrategy = EmptyMapBookingStrategy()) {
        self.pickupOnlyStrategy = pickupOnlyStrategy
        self.destinationSetStrategy = destinationSetStrategy
        self.journeyDetailsController = journeyDetailsController
        self.emptyBookingStrategy = emptyBookingStrategy
        pickupOnlyStrategy.set(delegate: self)
        journeyDetailsController.add(observer: self)
        currentStrategy = getStrategyToUse(details: journeyDetailsController.getJourneyDetails())
    }

    deinit {
        journeyDetailsController.remove(observer: self)
    }

    func load(map: MapView?, reverseGeolocate: Bool = true) {
        pickupOnlyStrategy.load(map: map, reverseGeolocate: reverseGeolocate)
        destinationSetStrategy.load(map: map, reverseGeolocate: reverseGeolocate)
        emptyBookingStrategy.load(map: map, reverseGeolocate: reverseGeolocate)
        currentStrategy?.start(journeyDetails: journeyDetailsController.getJourneyDetails())
    }

    func focusMap() {
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
        journeyDetailsController.set(pickup: pickup)
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
