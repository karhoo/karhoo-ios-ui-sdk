//
//  TripMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import CoreLocation
import KarhooSDK

protocol TripPresenter {

    func load(view: TripView?)

    func screenDidLayoutSubviews()

    func screenDidDisappear()

    func screenAppeared()

    func cancelBookingPressed()

    func callDriverPressed()

    func callFleetPressed()

    func locatePressed()

    func userMovedMap()

    func userDidCloseJourney()
}

protocol TripView: BaseViewController {

    func currentTrip() -> TripInfo

    func set(trip: TripInfo)

    func update(driverLocation: CLLocation)

    func showLoading()

    func hideLoading()

    func setAddressBar(with trip: TripInfo)

    func plotPinsOnMap()

    func focusMapOnRoute()

    func focusMapOnDriverAndPickup()

    func focusMapOnDriverAndDestination()

    func userMovedMap()

    func set(locateButtonHidden: Bool)

    func set(userMarkerVisible: Bool)
}

public enum TripScreenResult {
    case rebookTrip(rebookDetails: BookingDetails)
    case closed
}
