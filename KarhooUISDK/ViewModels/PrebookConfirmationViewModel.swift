//
//  PrebookConfirmationViewModel.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

final class PrebookConfirmationViewModel {

    let title: String
    let originLocation: String
    let destinationLocation: String
    let time: String
    let date: String
    let price: String
    let priceTitle: String
    let buttonTitle: String
    let pickUpType: String
    let showPickUpType: Bool

    init(bookingDetails: BookingDetails,
         quote: Quote,
         dateFormatter: DateFormatterType = KarhooDateFormatter()) {
        self.title = UITexts.Booking.prebookConfirmed
        self.originLocation = bookingDetails.originLocationDetails?.address.displayAddress ?? ""
        self.destinationLocation = bookingDetails.destinationLocationDetails?.address.displayAddress ?? ""

        if let originTimeZone = bookingDetails.originLocationDetails?.timezone() {
            dateFormatter.set(timeZone: originTimeZone)
            self.date = dateFormatter.display(shortDate: bookingDetails.scheduledDate)
            self.time = dateFormatter.display(clockTime: bookingDetails.scheduledDate)
        } else {
            self.date = ""
            self.time = ""
        }

        self.price = CurrencyCodeConverter.toPriceString(quote: quote)
        self.priceTitle = quote.quoteType.description
        self.buttonTitle = UITexts.Booking.prebookConfirmedRideDetails
        self.showPickUpType = quote.pickUpType != .default &&
                              bookingDetails.originLocationDetails?.details.type == .airport

        switch quote.pickUpType {
        case .meetAndGreet: pickUpType = UITexts.Bookings.meetAndGreetPickup
        case .curbside: pickUpType = UITexts.Bookings.cubsidePickup
        case .standyBy: pickUpType = UITexts.Bookings.standBy
        default: pickUpType = ""
        }
    }
}
