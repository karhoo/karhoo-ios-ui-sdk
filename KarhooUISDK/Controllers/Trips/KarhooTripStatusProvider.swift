//
// Created by Aleksander Wedrychowski on 06/10/2022.
// Copyright (c) 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import WidgetKit

public protocol TripStatusListener: AnyObject {
    func tripStatusChanged(state: TripState)
}

public protocol TripStatusProvider: AnyObject {
    func monitorTrip(tripId: String)
    func stopMonitoringTrip()
    func add(listener: TripStatusListener)
    func remove(listener: TripStatusListener)
}

final class KarhooTripStatusProvider: TripStatusProvider {

    // MARK: - Shared instance
    
    static let shared = KarhooTripStatusProvider(tripService: Karhoo.getTripService())
    
    // MARK: - Properties
    
    private let tripService: TripService
    private var tripId: String?
    private var listeners: [TripStatusListener] = []
    private var tripStateObservable: Observable<TripState>?
    private var tripStateObserver: Observer<TripState>?

    // MARK: - Lifecycle

    init(
        tripService: TripService = Karhoo.getTripService()
    ) {
        self.tripService = tripService
    }

    // MARK: - Endpoints
    
    func add(listener: TripStatusListener) {
        listeners.append(listener)
    }

    func remove(listener: TripStatusListener) {
        listeners.removeAll(where: { $0 === listener })
    }

    func monitorTrip(tripId: String) {
        self.tripId = tripId

        let observer = Observer<TripState>.value { [weak self] state in
            self?.tripStatusUpdated(state: state)
        }

        let observable = tripService.status(tripId: tripId).observable()
        observable.subscribe(observer: observer)

        tripStateObserver = observer
        tripStateObservable = observable
    }

    func stopMonitoringTrip() {
        tripStateObservable?.unsubscribe(observer: tripStateObserver)
    }

    // MARK: - Private methods

    private func tripStatusUpdated(state: TripState) {
        print("TripStatusProvider - state \(state)")
        if let userDefaults = UserDefaults(suiteName: "group.com.karhooUISDK.DropIn") {
            userDefaults.set(state.rawValue, forKey: "state")
            if #available(iOS 14.0, *) {
                WidgetCenter.shared.reloadTimelines(ofKind: "LiveActivityWidget")
            }
        }
        listeners.forEach { $0.tripStatusChanged(state: state)}
    }
}
