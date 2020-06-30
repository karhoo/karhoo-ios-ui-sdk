//
//  KarhooTripAllocationPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

final class KarhooTripAllocationPresenter: TripAllocationPresenter {

    private var tripObserver: Observer<TripInfo>?
    private var tripObservable: Observable<TripInfo>?
    private let tripService: TripService
    private let view: TripAllocationView
    private var trip: TripInfo?
    private let analytics: Analytics

    init(tripService: TripService = Karhoo.getTripService(),
         analytics: Analytics = KarhooAnalytics(),
         view: TripAllocationView) {
        self.tripService = tripService
        self.analytics = analytics
        self.view = view
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
            view.tripCancelledBySystem(trip: trip)
            tripObservable?.unsubscribe(observer: tripObserver)
            view.resetCancelButtonProgress()
        case .driverEnRoute, .arrived, .passengerOnBoard, .completed:
            view.tripAllocated(trip: trip)
            tripObservable?.unsubscribe(observer: tripObserver)
            view.resetCancelButtonProgress()
        default: break
        }
    }

    private func identifier(_ trip: TripInfo) -> String {
        if Karhoo.configuration.authenticationMethod().isGuest() {
            return trip.followCode
        }
        return trip.tripId
    }
}
