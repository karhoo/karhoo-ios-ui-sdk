//
//  KarhooBookingMapPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import CoreLocation
import KarhooSDK

enum BookingPinTags: Int {
    case pickup = 1
    case destination = 2
}

final class KarhooBookingMapPresenter: BookingMapPresenter {

    private let pickupOnlyStrategy: BookingMapStrategy
    private let destinationSetStrategy: BookingMapStrategy
    private let emptyBookingStrategy: BookingMapStrategy
    private var currentStrategy: BookingMapStrategy?
    private let bookingStatus: BookingStatus

    init(pickupOnlyStrategy: PickupOnlyStrategyProtocol = PickupOnlyStrategy(),
         destinationSetStrategy: BookingMapStrategy = DestinationSetStrategy(),
         bookingStatus: BookingStatus =  KarhooBookingStatus.shared,
         emptyBookingStrategy: BookingMapStrategy = EmptyMapBookingStrategy()) {
        self.pickupOnlyStrategy = pickupOnlyStrategy
        self.destinationSetStrategy = destinationSetStrategy
        self.bookingStatus = bookingStatus
        self.emptyBookingStrategy = emptyBookingStrategy
        pickupOnlyStrategy.set(delegate: self)
        bookingStatus.add(observer: self)
        currentStrategy = getStrategyToUse(details: bookingStatus.getBookingDetails())
    }

    deinit {
        bookingStatus.remove(observer: self)
    }

    func load(map: MapView?, reverseGeolocate: Bool = false) {
        pickupOnlyStrategy.load(map: map)
        destinationSetStrategy.load(map: map)
        emptyBookingStrategy.load(map: map)
        currentStrategy?.start(bookingDetails: bookingStatus.getBookingDetails())
    }

    func focusMap() {
        currentStrategy?.focusMap()
    }

    private func getStrategyToUse(details: BookingDetails?) -> BookingMapStrategy {
        if details?.originLocationDetails == nil && details?.destinationLocationDetails == nil {
            return emptyBookingStrategy
        } else if details?.originLocationDetails != nil && details?.destinationLocationDetails == nil {
            return pickupOnlyStrategy
        } else {
            return destinationSetStrategy
        }
    }

    private func changeTo(strategy: BookingMapStrategy, details: BookingDetails?) {
        currentStrategy?.stop()
        currentStrategy = strategy
        currentStrategy?.start(bookingDetails: details)
    }
}

extension KarhooBookingMapPresenter: PickupOnlyStrategyDelegate {

    func setFromMap(pickup: LocationInfo?) {
        bookingStatus.set(pickup: pickup)
    }

    func pickupFailedToSetFromMap(error: KarhooError?) {
        print("pickup failed: error: \(String(describing: error?.message))")
    }
}

extension KarhooBookingMapPresenter: BookingDetailsObserver {

    func bookingStateChanged(details: BookingDetails?) {
        let strategyToUse = getStrategyToUse(details: details)

        if strategyToUse !== currentStrategy {
            changeTo(strategy: strategyToUse, details: details)
        } else {
            currentStrategy?.changed(bookingDetails: details)
        }
    }
}
