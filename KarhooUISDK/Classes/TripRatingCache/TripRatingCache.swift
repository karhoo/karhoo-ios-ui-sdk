//
//  TripRatingCache.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol TripRatingCache {

    func saveTripRated(tripId: String)

    func tripRated(tripId: String) -> Bool

    func clearTripRatings()
}
