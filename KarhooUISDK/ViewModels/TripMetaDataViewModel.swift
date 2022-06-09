//
//  TripMetaDataViewModel.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import KarhooSDK
import UIKit

final class TripMetaDataViewModel {

    let status: String
    let statusColor: UIColor
    let statusIconName: String
    var price: String
    let priceType: String
    let displayId: String
    let flightNumber: String
    let baseFareHidden: Bool
    
    /// If this message is not `nil`, it should be displayed
    let freeCancellationMessage: String?

    init(trip: TripInfo) {
        displayId = trip.displayId
        flightNumber = trip.flightNumber
        status = TripInfoUtility.short(tripState: trip.state)
        let isPrebook = trip.dateBooked != trip.dateScheduled

        let bookingStatusViewModel = BookingStatusViewModel(trip: trip)
        statusColor = bookingStatusViewModel.statusColor
        statusIconName = bookingStatusViewModel.imageName

        switch trip.serviceAgreements?.serviceCancellation.type {
        case .timeBeforePickup:
            if let freeCancellationMinutes = trip.serviceAgreements?.serviceCancellation.minutes,
               freeCancellationMinutes > 0 {
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

        if TripStatesGetter().getStatesForTripRequest(type: .upcoming).contains(trip.state) &&
           trip.tripQuote.type != .fixed {
            priceType = UITexts.Booking.baseFare
            price = trip.quotePrice()
            baseFareHidden = false
            return
        }

        if trip.state == .completed {
            price = trip.farePrice()
        } else if TripInfoUtility.isCancelled(trip: trip),
            trip.fare.total != 0 {
            price = trip.farePrice()
        } else {
            price = trip.quotePrice()
        }
        
        baseFareHidden = true
        priceType = UITexts.Bookings.price
    }
    
    func setFare(_ fare: Fare) {
        price = fare.displayPrice()
    }
}
