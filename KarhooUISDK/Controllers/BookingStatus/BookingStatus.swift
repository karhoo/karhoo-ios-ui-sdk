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
    func bookingStateChanged(details: JourneyDetails?)
}

public protocol BookingStatus {
    func add(observer: BookingDetailsObserver)
    func remove(observer: BookingDetailsObserver)

    func set(pickup: LocationInfo?)
    func set(destination: LocationInfo?)
    func set(prebookDate: Date?)
    func reset(with bookingDetails: JourneyDetails)
    func reset()
    func setJourneyInfo(journeyInfo: JourneyInfo?)
    func getBookingDetails() -> JourneyDetails?
}
