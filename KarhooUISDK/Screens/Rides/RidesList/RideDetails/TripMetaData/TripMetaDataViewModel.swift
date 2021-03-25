//
//  TripMetaDataViewModel.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import KarhooSDK

final class TripMetaDataViewModel {

    let status: String
    let statusColor: UIColor
    let statusIconName: String
    var price: String
    let priceType: String
    let displayId: String
    let flightNumber: String
    let baseFareHidden: Bool
    let showRateTrip: Bool

    /// If this message is not `nil`, it should be displayed
    let freeCancellationMessage: String?

    init(trip: TripInfo) {
        displayId = trip.displayId
        flightNumber = trip.flightNumber
        status = TripInfoUtility.short(tripState: trip.state)
        showRateTrip = trip.state == .completed

        let bookingStatusViewModel = BookingStatusViewModel(trip: trip)
        statusColor = bookingStatusViewModel.statusColor
        statusIconName = bookingStatusViewModel.imageName

        if let freeCancellationMinutes = trip.serviceAgreements?.serviceCancellation.minutes,
           freeCancellationMinutes > 0 {
            freeCancellationMessage = String(format: UITexts.Quotes.freeCancellation, "\(freeCancellationMinutes)")
        } else if trip.serviceAgreements?.serviceCancellation.type == "BeforeDriverEnRoute" {
            freeCancellationMessage = UITexts.Quotes.freeCancellationBeforeDriverEnRoute
        } else {
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
