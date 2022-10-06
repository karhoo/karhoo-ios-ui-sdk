//
// Created by Aleksander Wedrychowski on 06/10/2022.
// Copyright (c) 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

public protocol TripUpdateListener: AnyObject {
    func tripStatusChanged(tripInfo: TripInfo, currentState: TripState)
}

public protocol TripInfoUpdateProvider: AnyObject {
    func monitorTrip(tripInfo: TripInfo)
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
    private var tripStateUpdateObservable: Observable<TripState>?
    private var tripStateUpdateObserver: Observer<TripState>?
    
    private(set) var tripInfo: TripInfo?
    private let tripInfoPollingInterval: TimeInterval = 30

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

    func monitorTrip(tripInfo: TripInfo) {
        self.tripId = tripInfo.tripId

        let observer = Observer<TripInfo>.value { [weak self] tripInfo in
            self?.tripInfoUpdated(tripInfo: tripInfo)
        }

        let stateObserver = Observer<TripState>.value { [weak self] state in
            self?.tripInfoUpdated(state: state)
        }

        let observable = tripService
            .trackTrip(identifier: identifier(tripInfo))
            .observable()
        observable.subscribe(observer: observer)
        
        let stateObservable = tripService
            .status(tripId: tripInfo.tripId)
            .observable()
        stateObservable.subscribe(observer: stateObserver)

        tripUpdateObserver = observer
        tripUpdateObservable = observable
        
        tripStateUpdateObserver = stateObserver
        tripStateUpdateObservable = stateObservable
    }

    func stopMonitoringTrip() {
        tripUpdateObservable?.unsubscribe(observer: tripUpdateObserver)
        tripStateUpdateObservable?.unsubscribe(observer: tripStateUpdateObserver)
    }

    // MARK: - Private methods

    private func tripInfoUpdated(state: TripState) {
        print("TripInfoUpdateProvider - state \(state)")
        guard let tripInfo else { return }
        
        listeners.forEach { $0.tripStatusChanged(tripInfo: tripInfo, currentState: tripInfo.state)}

        if tripInfo.state == .completed {
            stopMonitoringTrip()
        }
    }

    private func tripInfoUpdated(tripInfo: TripInfo) {
        self.tripInfo = tripInfo
        print("TripInfoUpdateProvider - info update \(tripInfo.state)")
        listeners.forEach { $0.tripStatusChanged(tripInfo: tripInfo, currentState: tripInfo.state)}
        
        if tripInfo.state == .completed {
            stopMonitoringTrip()
        }
    }

    private func identifier(_ trip: TripInfo) -> String {
        if Karhoo.configuration.authenticationMethod().isGuest() {
            return trip.followCode
        }
        return trip.tripId
    }
}
