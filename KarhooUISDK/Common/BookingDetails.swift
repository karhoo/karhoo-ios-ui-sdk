//
//  BookingDetails.swift
//  KarhooSDK
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK

public struct BookingDetails: Equatable {

    public var originLocationDetails: LocationInfo?
    public var destinationLocationDetails: LocationInfo?
    public var scheduledDate: Date?

    public init(originLocationDetails: LocationInfo? = nil) {
        self.originLocationDetails = originLocationDetails
    }

    public var isScheduled: Bool {
        guard let scheduled = scheduledDate else {
            return false
        }

        return scheduled.timeIntervalSince1970 != 0
    }

    public func reverse() -> BookingDetails? {

        guard let initialDestination = self.destinationLocationDetails else {
            return nil
        }
        let initialPickup = self.originLocationDetails

        var newBookingDetails = BookingDetails(originLocationDetails: initialDestination)
        newBookingDetails.destinationLocationDetails = initialPickup

        return newBookingDetails
    }

    static public func == (lhs: BookingDetails, rhs: BookingDetails) -> Bool {
        return lhs.originLocationDetails?.placeId == rhs.originLocationDetails?.placeId
            && lhs.destinationLocationDetails?.placeId == rhs.destinationLocationDetails?.placeId
            && lhs.scheduledDate == rhs.scheduledDate
    }

}
