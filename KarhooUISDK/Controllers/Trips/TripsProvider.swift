//
//  TripsProvider.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

public protocol TripsProviderDelegate: AnyObject {
    func fetched(trips: [TripInfo])
    func tripProviderFailed(error: KarhooError?)
}

public protocol TripsProvider {
    func start()
    func stop()
    func requestNewPage(pageOffset: Int)
    var delegate: TripsProviderDelegate? { get set }
}

extension TripsProvider {
    // Used for late shouldPoll value change in unit tests
    private func setShouldPoll(to newValue: Bool) {}
}

public enum TripsRequestType {
    case past, upcoming
}

public final class TripStatesGetter {

    func getStatesForTripRequest(type: TripsRequestType) -> [TripState] {
        if type == .past {
            return [.driverCancelled,
                    .bookerCancelled,
                    .karhooCancelled,
                    .completed,
                    .noDriversAvailable,
                    .incomplete]
        }

        return [.requested,
                .confirmed,
                .driverEnRoute,
                .arrived,
                .passengerOnBoard]
    }
}
