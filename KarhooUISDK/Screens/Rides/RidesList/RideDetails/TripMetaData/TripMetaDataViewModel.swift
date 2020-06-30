//
//  TripMetaDataViewModel.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import KarhooSDK

final class TripMetaDataViewModel {

    public let status: String
    public let statusColor: UIColor
    public let statusIconName: String
    public var price: String
    public let priceType: String
    public let displayId: String
    public let flightNumber: String
    public let baseFareHidden: Bool
    public let showRateTrip: Bool

    init(trip: TripInfo) {
        displayId = trip.displayId
        flightNumber = trip.flightNumber
        status = TripInfoUtility.short(tripState: trip.state)
        showRateTrip = trip.state == .completed

        let bookingStatusViewModel = BookingStatusViewModel(trip: trip)
        statusColor = bookingStatusViewModel.statusColor
        statusIconName = bookingStatusViewModel.imageName

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
