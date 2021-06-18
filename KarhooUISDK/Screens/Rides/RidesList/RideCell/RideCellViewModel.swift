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
        let isPrebook = trip.dateBooked != trip.dateScheduled

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

        switch trip.serviceAgreements?.serviceCancellation.type {
        case .timeBeforePickup:
            if let freeCancellationMinutes = trip.serviceAgreements?.serviceCancellation.minutes, freeCancellationMinutes > 0 {
                let timeBeforeCancel = TimeFormatter().minutesAndHours(timeInMinutes: freeCancellationMinutes)
                let messageFormat = isPrebook == true ? UITexts.Quotes.freeCancellationPrebook : UITexts.Quotes.freeCancellationASAP
                freeCancellationMessage = String(format: messageFormat, timeBeforeCancel)
            } else {
                freeCancellationMessage = nil
            }
        case .beforeDriverEnRoute:
            freeCancellationMessage = UITexts.Quotes.freeCancellationBeforeDriverEnRoute
        default:
            freeCancellationMessage = nil
        }
    }
}
