//
//  BookingStatusViewModel.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import KarhooSDK
import UIKit

final class BookingStatusViewModel {

    public let imageName: String
    public let statusColor: UIColor

    init(trip: TripInfo) {
        self.statusColor = KarhooUI.colors.darkGrey

        if TripInfoUtility.isCancelled(trip: trip) || trip.state == .incomplete {
            self.imageName =  "kh_uisdk_trip_cancelled"
        } else if trip.state == .completed {
            self.imageName = "kh_uisdk_trip_completed"
        } else {
            self.imageName = ""
        }
    }
}
