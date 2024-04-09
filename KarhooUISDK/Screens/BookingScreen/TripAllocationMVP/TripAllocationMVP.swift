//
//  TripAllocationMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

public protocol TripAllocationView: BaseView {
    func tripAllocated(trip: TripInfo)

    func tripCancellationRequestSucceeded()

    func tripCancelledBySystem(trip: TripInfo)

    func tripCancellationRequestFailed(error: KarhooError?, trip: TripInfo)
    
    func tripDriverAllocationDelayed(trip: TripInfo)
    
    func presentScreen(forTrip trip: TripInfo)

    func resetCancelButtonProgress()
    
    func set(actions: TripAllocationActions)
    
    func dismissScreen()
}

protocol TripAllocationPresenter {
    
    func cancelTrip()

    func startMonitoringTrip(trip: TripInfo)
    
    func stopMonitoringTrip()
}

public protocol TripAllocationActions: AnyObject {

    func cancelTripFailed(error: KarhooError?, trip: TripInfo)
    
    func tripAllocated(trip: TripInfo)

    func tripCancelledBySystem(trip: TripInfo)
    
    func tripDriverAllocationDelayed(trip: TripInfo)
    
    func userSuccessfullyCancelledTrip()
}
