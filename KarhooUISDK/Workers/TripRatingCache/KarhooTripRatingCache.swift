//
//  KarhooTripRatingCache.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooTripRatingCache: TripRatingCache {

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    func saveTripRated(tripId: String) {
        userDefaults.set(true, forKey: tripId)
    }

    func tripRated(tripId: String) -> Bool {
        return userDefaults.bool(forKey: tripId)
    }

    func clearTripRatings() {
        userDefaults.removePersistentDomain(forName: Bundle.current.bundleIdentifier ?? "")
        userDefaults.synchronize()
    }
}
