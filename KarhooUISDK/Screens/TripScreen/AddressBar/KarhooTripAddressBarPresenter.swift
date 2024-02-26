//
//  KarhooTripAddressBarPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK

final class KarhooTripAddressBarPresenter: TripAddressBarPresenter {

    private let trip: TripInfo

    init(trip: TripInfo) {
        self.trip = trip
    }

    func load(view: AddressBarView?) {
        view?.set(pickupDisplayAddress: trip.origin.displayAddress)
        view?.set(destinationDisplayAddress: trip.destination?.displayAddress)
        view?.setDisplayTripState()
    }
}
