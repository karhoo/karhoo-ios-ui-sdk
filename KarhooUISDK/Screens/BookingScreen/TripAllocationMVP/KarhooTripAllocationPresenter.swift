//
//  KarhooTripAllocationPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK
import CoreFoundation

final class KarhooTripAllocationPresenter: TripAllocationPresenter {

    private var tripObserver: Observer<TripInfo>?
    private var tripObservable: Observable<TripInfo>?
    private let tripService: TripService
    private let view: TripAllocationView
    private var trip: TripInfo?
    private let analytics: Analytics
    private let driverAllocationCheckDelay: Double
    private var displayDriverAllocationAlert: Bool = false

    init(tripService: TripService = Karhoo.getTripService(),
         analytics: Analytics = KarhooAnalytics(),
         view: TripAllocationView,
         driverAllocationCheckDelay: Double = 60.0) {
        self.tripService = tripService
        self.analytics = analytics
        self.view = view
        self.driverAllocationCheckDelay = driverAllocationCheckDelay
    }

    func startMonitoringTrip(trip: TripInfo) {
        self.trip = trip

        tripObservable = tripService.trackTrip(identifier: identifier(trip)).observable()

        tripObserver = Observer<TripInfo> { [weak self] result in
            switch result {
            case .success(let trip): self?.tripUpdateReceived(trip: trip)
            default: break
            }
        }

        tripObservable?.subscribe(observer: tripObserver)
        
        displayDriverAllocationAlert = true
        displayDriverAllocationDelayAlert()
    }
    
    func stopMonitoringTrip() {
        tripObservable?.unsubscribe(observer: tripObserver)
    }

    func cancelTrip() {
        guard let trip = self.trip else {
            return
        }

        analytics.tripAllocationCancellationIntiatedByUser(trip: trip)

        let tripCancellation = TripCancellation(tripId: identifier(trip),
                                                cancelReason: .otherUserReason)

        tripService.cancel(tripCancellation: tripCancellation).execute(callback: { [weak self] result in
            self?.view.resetCancelButtonProgress()

            if result.isSuccess() {
                self?.view.tripCancellationRequestSucceeded()
                self?.tripObservable?.unsubscribe(observer: self?.tripObserver)
            } else {
                self?.view.tripCancellationRequestFailed(error: result.errorValue(), trip: trip)
            }
        })
    }

    private func tripUpdateReceived(trip: TripInfo) {
        switch trip.state {
        case .driverCancelled, .karhooCancelled, .noDriversAvailable:
            displayDriverAllocationAlert = false
            view.tripCancelledBySystem(trip: trip)
            stopMonitoringTrip()
            view.resetCancelButtonProgress()
        case .driverEnRoute, .arrived, .passengerOnBoard, .completed:
            displayDriverAllocationAlert = false
            view.tripAllocated(trip: trip)
            stopMonitoringTrip()
            view.resetCancelButtonProgress()
        default: break
        }
    }
    
    private func displayDriverAllocationDelayAlert() {
        if !Karhoo.configuration.authenticationMethod().isGuest() {
            DispatchQueue.global().asyncAfter(deadline: .now() + driverAllocationCheckDelay) { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    self?.handleDriverAllocationDelay()
                }
            }
        }
    }
    
    func handleDriverAllocationDelay() {
        if displayDriverAllocationAlert == true, let trip = trip {
            view.tripDriverAllocationDelayed(trip: trip)
        }
    }
    
    private func identifier(_ trip: TripInfo) -> String {
        if Karhoo.configuration.authenticationMethod().isGuest() {
            return trip.followCode
        }
        return trip.tripId
    }
}
