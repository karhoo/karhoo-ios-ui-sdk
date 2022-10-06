//
// Created by Aleksander Wedrychowski on 06/10/2022.
// Copyright (c) 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

public protocol TripUpdateListener: AnyObject {
    func tripStatusChanged(tripInfo: TripInfo)
}

public protocol TripInfoUpdateProvider: AnyObject {
    func monitorTrip(tripId: String)
    func stopMonitoringTrip()
    func add(listener: TripUpdateListener)
    func remove(listener: TripUpdateListener)
}

final class KarhooTripInfoUpdateProvider: TripInfoUpdateProvider {

    // MARK: - Shared instance
    
    static let shared = KarhooTripInfoUpdateProvider(tripService: Karhoo.getTripService())
    
    // MARK: - Properties
    
    private let tripService: TripService
    private var tripId: String?
    private var listeners: [TripUpdateListener] = []
    private var tripUpdateObservable: Observable<TripInfo>?
    private var tripUpdateObserver: Observer<TripInfo>?
    private(set) var tripInfo: TripInfo?

    // MARK: - Lifecycle

    init(
        tripService: TripService = Karhoo.getTripService()
    ) {
        self.tripService = tripService
    }

    // MARK: - Endpoints
    
    func add(listener: TripUpdateListener) {
        listeners.append(listener)
    }

    func remove(listener: TripUpdateListener) {
        listeners.removeAll(where: { $0 === listener })
    }

    func monitorTrip(tripId: String) {
        self.tripId = tripId

        let observer = Observer<TripInfo>.value { [weak self] tripInfo in
            self?.tripInfoUpdated(tripInfo: tripInfo)
        }

        let observable = tripService.trackTrip(identifier: tripId).observable()
        observable.subscribe(observer: observer)

        tripUpdateObserver = observer
        tripUpdateObservable = observable
    }

    func stopMonitoringTrip() {
        tripUpdateObservable?.unsubscribe(observer: tripUpdateObserver)
    }

    // MARK: - Private methods

    private func tripInfoUpdated(tripInfo: TripInfo) {
        self.tripInfo = tripInfo
        print("TripInfoUpdateProvider - state \(tripInfo.state)")
        listeners.forEach { $0.tripStatusChanged(tripInfo: tripInfo)}
    }
}
