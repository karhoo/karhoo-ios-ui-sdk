//
//  KarhooOriginEtaPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

final class KarhooOriginEtaPresenter: OriginEtaPresenter {

    private let tripService: TripService
    private let driverTrackingService: DriverTrackingService
    private let etaView: OriginEtaView
    private var tripId: String?
    private var currentlyListeningToDriverLocation: Bool = false

    private var driverTrackingObservable: Observable<DriverTrackingInfo>?
    private var driverTrackingObserver: Observer<DriverTrackingInfo>?

    private var tripStateObservable: Observable<TripState>?
    private var tripStateObserver: Observer<TripState>?

    init(tripService: TripService = Karhoo.getTripService(),
         driverTrackingService: DriverTrackingService = Karhoo.getDriverTrackingService(),
         etaView: OriginEtaView) {
        self.tripService = tripService
        self.driverTrackingService = driverTrackingService
        self.etaView = etaView
    }

    func monitorTrip(tripId: String) {
        etaView.hide()
        self.tripId = tripId

        let observer = Observer<TripState>.value { [weak self] status in
            self?.tripStatusUpdated(status: status)
        }

        let observable = tripService.status(tripId: tripId).observable()
        observable.subscribe(observer: observer)

        tripStateObserver = observer
        tripStateObservable = observable

    }

    func stopMonitoringTrip() {
        tripStateObservable?.unsubscribe(observer: tripStateObserver)
        stopListeningForDriverLocation()
    }

    func updated(info: DriverTrackingInfo) {
        let etaToOrigin = info.originEta

        if etaToOrigin == 0 {
            etaView.hide()
        } else {
            etaView.show(eta: "\(etaToOrigin)")
        }
    }

    func tripStatusUpdated(status: TripState) {
        if status == .driverEnRoute {
            listenForDriverLocation()
        } else if status == .completed {
            etaView.hide()
            stopMonitoringTrip()
        } else {
            etaView.hide()
            stopListeningForDriverLocation()
        }
    }

    private func listenForDriverLocation() {
        guard currentlyListeningToDriverLocation == false else {
            return
        }
        driverTrackingObservable?.unsubscribe(observer: driverTrackingObserver)

        if let tripId = self.tripId {
            let observer = Observer<DriverTrackingInfo>.value { [weak self] info in
                self?.updated(info: info)
            }
            let observable = driverTrackingService.trackDriver(tripId: tripId).observable()
            observable.subscribe(observer: observer)

            driverTrackingObservable = observable
            driverTrackingObserver = observer
        }
        currentlyListeningToDriverLocation = true
    }

    private func stopListeningForDriverLocation() {
        if currentlyListeningToDriverLocation == false {
            return
        }
        driverTrackingObservable?.unsubscribe(observer: driverTrackingObserver)
        currentlyListeningToDriverLocation = false
    }
}
