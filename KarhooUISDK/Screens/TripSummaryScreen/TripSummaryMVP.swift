//
//  TripSummaryMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

protocol TripSummaryPresenter {
    func viewLoaded(view: TripSummaryView)
    func bookReturnRidePressed()
    func exitPressed()
}

protocol TripSummaryView: AnyObject {
    func set(trip: TripInfo)
}

public enum TripSummaryResult {
    case rebookWithJourneyDetails(_: JourneyDetails)
    case closed
}
