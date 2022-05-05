//
//  KarhooTripsProvider.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import KarhooSDK
import Foundation

public final class KarhooTripsProvider: TripsProvider {

    private let pollTime: TimeInterval = 10
    private let reachability: ReachabilityProvider
    private let tripService: TripService
    private let requestType: TripsRequestType
    private let shouldPoll: Bool
    private let timer: TimeScheduler
    private var itemsOffset: Int = 0
    private let pageSize: Int = 10
    private var noMoreItems: Bool = false

    weak public var delegate: TripsProviderDelegate?

    public init(reachability: ReachabilityProvider = ReachabilityWrapper.shared,
                tripService: TripService = Karhoo.getTripService(),
                tripRequestType: TripsRequestType,
                shouldPoll: Bool = false,
                timer: TimeScheduler = KarhooTimeScheduler()) {
        self.reachability = reachability
        self.tripService = tripService
        self.requestType = tripRequestType
        self.shouldPoll = shouldPoll
        self.timer = timer
    }

    public func start() {
        self.reachability.add(listener: self)

        if shouldPoll {
            timer.schedule(block: { [weak self] in
                self?.loadTrips()
            }, in: pollTime, repeats: true)
        }
    }
    
    public func stop() {
        self.reachability.remove(listener: self)
        self.timer.invalidate()
    }

    deinit {
        stop()
    }

    fileprivate func loadTrips() {
        let tripSearch = TripSearch(tripStates: TripStatesGetter().getStatesForTripRequest(type: requestType),
                                    paginationRowCount: pageSize,
                                    paginationOffset: itemsOffset)

        tripService.search(tripSearch: tripSearch)
                    .execute(callback: { [weak self] (result: Result<[TripInfo]>) in
            guard result.isSuccess() else {
                self?.delegate?.tripProviderFailed(error: result.errorValue())
                return
            }

            guard let trips = result.successValue() else {
                self?.delegate?.fetched(trips: [])
                return
            }
        
            self?.noMoreItems = trips.count == 0 ? true : false
            self?.delegate?.fetched(trips: trips)
        })
    }
    
    public func requestNewPage(pageOffset: Int) {
        if !noMoreItems {
            itemsOffset = pageOffset
            loadTrips()
        }
    }
}

extension KarhooTripsProvider: ReachabilityListener {
    public func reachabilityChanged(isReachable: Bool) {
        loadTrips()
    }
}
