//
//  KarhooTripDetailsPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

final class KahrooTripScreenDetailsPresenter: TripScreenDetailsPresenter {

    private let tripService: TripService
    private let view: TripScreenDetailsView?
    private var trip: TripInfo?
    private var tripObservable: Observable<TripInfo>?
    private var tripObserver: Observer<TripInfo>?

    init(tripService: TripService = Karhoo.getTripService(),
         view: TripScreenDetailsView) {
        self.tripService = tripService
        self.view = view
    }

    func startMonitoringTrip(tripId: String) {
        tripObserver = Observer { [weak self] result in
            switch result {
            case .success(let trip, _):
                self?.handleTripUpdate(trip: trip)
            case .failure(let error, _):
                self?.tripUpdateFailed(error: error)
            @unknown default:
                print("Unknown enum value in KahrooTripScreenDetailsPresenter.startMonitoringTrip")
            }
        }

        tripObservable = tripService.trackTrip(identifier: tripId).observable()
        tripObservable?.subscribe(observer: tripObserver)
    }

    func stopMonitoringTrip() {
        tripObservable?.unsubscribe(observer: tripObserver)
    }

    private func handleTripUpdate(trip: TripInfo) {
        self.trip = trip
        view?.updateViewModel(tripDetailsViewModel: TripScreenDetailsViewModel(trip: trip))
    }

    private func tripUpdateFailed(error: KarhooError?) {}
}
