//
//  KarhooDestinationEtaPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK
import Foundation
import CoreGraphics

final class KarhooDestinationEtaPresenter: DestinationEtaPresenter {

    private let secondsInMinute = 60
    private let tripService: TripService
    private let driverTrackingService: DriverTrackingService
    private let etaView: DestinationEtaView
    private var tripId: String?
    private var currentlyListeningToDriverLocation: Bool = false
    private let timeFetcher: TimeFetcher
    private let dateFormatterType: DateFormatterType
    private var driverTrackingObservable: Observable<DriverTrackingInfo>?
    private var driverTrackingObserver: Observer<DriverTrackingInfo>?

    private var tripStatusObservable: Observable<TripState>?
    private var tripStatusObserver: Observer<TripState>?

    init(tripService: TripService = Karhoo.getTripService(),
         driverTrackingService: DriverTrackingService = Karhoo.getDriverTrackingService(),
         timeFetcher: TimeFetcher = KarhooTimeFetcher(),
         etaView: DestinationEtaView,
         dateFormatterType: DateFormatterType = KarhooDateFormatter()) {
        self.tripService = tripService
        self.driverTrackingService = driverTrackingService
        self.etaView = etaView
        self.timeFetcher = timeFetcher
        self.dateFormatterType = dateFormatterType
    }

    func monitorTrip(tripId: String) {
        etaView.hide()
        self.tripId = tripId

        tripStatusObserver = Observer<TripState>.value { [weak self] status in
            self?.tripStatusUpdated(status: status)
        }
        tripStatusObservable = tripService.status(tripId: tripId).observable()
        tripStatusObservable!.subscribe(observer: tripStatusObserver!)
    }

    func stopMonitoringTrip() {
        tripStatusObservable?.unsubscribe(observer: tripStatusObserver)
        stopListeningToDriverLocation()
    }

    func updated(info: DriverTrackingInfo) {
        let etaToDestination = info.destinationEta

        if etaToDestination == 0 {
            etaView.hide()
        } else {
            let now = timeFetcher.now().timeIntervalSince1970
            let arrivalDate: Date = Date(timeIntervalSince1970: now + TimeInterval(etaToDestination * secondsInMinute))
            let eta = dateFormatterType.display(clockTime: arrivalDate)

            etaView.show(eta: eta)
        }
    }

    func tripStatusUpdated(status: TripState) {
        if status == .passengerOnBoard {
            listenToDriverLocation()
        } else if status == .completed {
            etaView.hide()
            stopMonitoringTrip()
        } else {
            etaView.hide()
            stopListeningToDriverLocation()
        }
    }

    private func listenToDriverLocation() {
        guard currentlyListeningToDriverLocation == false else {
            return
        }
        driverTrackingObservable?.unsubscribe(observer: driverTrackingObserver)

        if let tripId = self.tripId {
            driverTrackingObserver = Observer<DriverTrackingInfo>.value { [weak self] info in
                self?.updated(info: info)
            }

            driverTrackingObservable = driverTrackingService.trackDriver(tripId: tripId).observable()
            driverTrackingObservable?.subscribe(observer: driverTrackingObserver!)

            currentlyListeningToDriverLocation = true
        }
    }

    private func stopListeningToDriverLocation() {
        if currentlyListeningToDriverLocation == false {
            return
        }

        driverTrackingObservable?.unsubscribe(observer: driverTrackingObserver)
        currentlyListeningToDriverLocation = false
    }
}
