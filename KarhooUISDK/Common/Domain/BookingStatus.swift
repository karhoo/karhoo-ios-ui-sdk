//
//  BookingStatus.swift
//  KarhooSDK
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK

public protocol BookingDetailsObserver: AnyObject {
    func bookingStateChanged(details: BookingDetails?)
}

public protocol BookingStatus {
    func add(observer: BookingDetailsObserver)
    func remove(observer: BookingDetailsObserver)

    func set(pickup: LocationInfo?)
    func set(destination: LocationInfo?)
    func set(prebookDate: Date?)
    func reset(with bookingDetails: BookingDetails)
    func reset()
    func setJourneyInfo(journeyInfo: TripLocationInfo?)
    func getBookingDetails() -> BookingDetails?
}
