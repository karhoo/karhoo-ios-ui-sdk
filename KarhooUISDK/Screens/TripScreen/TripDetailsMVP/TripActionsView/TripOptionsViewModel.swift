//
//  TripOptionsViewModel.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

struct TripOptionsViewModel {

    let tripContactInfo: String
    let tripContactNumber: String
    let cancelEnabled: Bool

    init(trip: TripInfo) {
        cancelEnabled = TripInfoUtility.canCancel(trip: trip)

        if trip.state == .passengerOnBoard {
            tripContactInfo = UITexts.Trip.tripContactFleet
            tripContactNumber = trip.fleetInfo.phoneNumber
            return
        }

        if TripInfoUtility.canContactDriver(trip: trip) {
            tripContactInfo = UITexts.Trip.tripContactDriver
            tripContactNumber = trip.vehicle.driver.phoneNumber
        } else {
            tripContactInfo = UITexts.Trip.tripContactFleet
            tripContactNumber = trip.fleetInfo.phoneNumber
        }
    }
}
