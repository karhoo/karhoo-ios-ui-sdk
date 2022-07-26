//
//  BookingDetails.swift
//  KarhooSDK
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK

public struct JourneyDetails: Equatable {

    public var originLocationDetails: LocationInfo?
    public var destinationLocationDetails: LocationInfo?
    public var scheduledDate: Date?
    public var luggagesCount: Int = 0
    public var passangersCount: Int = 1

    public init(originLocationDetails: LocationInfo? = nil) {
        self.originLocationDetails = originLocationDetails
    }

    public var isScheduled: Bool {
        guard let scheduled = scheduledDate else {
            return false
        }

        return scheduled.timeIntervalSince1970 != 0
    }

    public func reverse() -> JourneyDetails? {

        guard let initialDestination = self.destinationLocationDetails else {
            return nil
        }
        let initialPickup = self.originLocationDetails

        var newBookingDetails = JourneyDetails(originLocationDetails: initialDestination)
        newBookingDetails.destinationLocationDetails = initialPickup

        return newBookingDetails
    }

    static public func == (lhs: JourneyDetails, rhs: JourneyDetails) -> Bool {
        return lhs.originLocationDetails?.placeId == rhs.originLocationDetails?.placeId
            && lhs.destinationLocationDetails?.placeId == rhs.destinationLocationDetails?.placeId
            && lhs.scheduledDate == rhs.scheduledDate
    }

}
