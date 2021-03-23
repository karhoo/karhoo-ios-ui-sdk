//
//  RideCellViewModel.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

final class RideCellViewModel {

    public let price: String
    public let tripState: String
    public let tripStateIconName: String
    public let tripStateColor: UIColor
    public let trip: TripInfo
    public let tripDetailsViewModel: TripDetailsViewModel
    public let showActionButtons: Bool

    /// If this message is not `nil`, it should be displayed
    let freeCancellationMessage: String?

    init(trip: TripInfo) {
        self.trip = trip

        if trip.state == .completed {
            price = trip.farePrice()
        } else if TripInfoUtility.isCancelled(trip: trip) {
                price = trip.farePrice()
        } else {
            price = trip.quotePrice()
        }

        tripDetailsViewModel = TripDetailsViewModel(trip: trip)
        tripState = TripInfoUtility.short(tripState: trip.state)

        if TripInfoUtility.isCancelled(trip: trip)
        || trip.state == .completed || trip.state == .incomplete {
            showActionButtons = false
        } else {
            showActionButtons = true
        }

        let bookingStatusViewModel = BookingStatusViewModel(trip: trip)
        tripStateColor = bookingStatusViewModel.statusColor
        tripStateIconName = bookingStatusViewModel.imageName

        if let freeCancellationMinutes = trip.serviceAgreements?.serviceCancellation.minutes,
           freeCancellationMinutes > 0 {
            freeCancellationMessage = String(format: UITexts.Quotes.freeCancellation, "\(freeCancellationMinutes)")
        } else {
            freeCancellationMessage = nil
        }
    }
}
