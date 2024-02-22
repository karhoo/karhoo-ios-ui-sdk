//
//  TripMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import CoreLocation
import Foundation
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

    func userDidCloseTrip()

    func contactDriver(_ phoneNumber: String)
    
    func contactFleet(_ phoneNumber: String)
}

protocol TripView: BaseViewController {

    func currentTrip() -> TripInfo

    func set(trip: TripInfo)

    func update(driverLocation: CLLocation)

    func showLoading()

    func hideLoading()

    func setAddressBar(with trip: TripInfo)

    func plotPinsOnMap()

    func focusMapOnAllPOI()

    func focusMapOnRoute()

    func focusOnUserLocation()

    func focusMapOnPickup()

    func focusMapOnDriverAndPickup()

    func focusMapOnDriver()

    func userMovedMap()

    func set(locateButtonHidden: Bool)

    func set(userMarkerVisible: Bool)

    func showNoLocationPermissionsPopUp()
}

public enum TripScreenResult {
    case rebookTrip(rebookDetails: JourneyDetails)
    case closed
}
