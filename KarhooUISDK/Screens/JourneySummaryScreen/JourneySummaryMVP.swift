//
//  JourneySummaryMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

protocol JourneySummaryPresenter {
    func viewLoaded(view: JourneySummaryView)
    func bookReturnRidePressed()
    func exitPressed()
}

protocol JourneySummaryView: AnyObject {
    func set(trip: TripInfo)
}

public enum JourneySummaryResult {
    case rebookWithBookingDetails(_: BookingDetails)
    case closed
}
