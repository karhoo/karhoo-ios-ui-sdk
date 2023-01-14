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

        let bookingStatusViewModel = BookingStatusViewModel(trip: trip)
        statusColor = bookingStatusViewModel.statusColor
        statusIconName = bookingStatusViewModel.imageName

        freeCancellationMessage = KarhooFreeCancelationTextWorker.getFreeCancelationText(trip: trip)

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
