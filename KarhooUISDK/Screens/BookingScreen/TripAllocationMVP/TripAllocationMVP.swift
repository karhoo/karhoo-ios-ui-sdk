//
//  BookingAllocationMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

protocol TripAllocationView {

    func set(actions: TripAllocationActions)

    func presentScreen(forTrip trip: TripInfo)

    func tripAllocated(trip: TripInfo)

    func tripCancellationRequestSucceeded()

    func tripCancelledBySystem(trip: TripInfo)

    func tripCancellationRequestFailed(error: KarhooError?, trip: TripInfo)

    func resetCancelButtonProgress()
}

protocol TripAllocationPresenter {

    func startMonitoringTrip(trip: TripInfo)

    func cancelTrip()
}

protocol TripAllocationActions: AnyObject {

    func tripAllocated(trip: TripInfo)

    func userSuccessfullyCancelledTrip()

    func cancelTripFailed(error: KarhooError?, trip: TripInfo)

    func tripCancelledBySystem(trip: TripInfo)
}
