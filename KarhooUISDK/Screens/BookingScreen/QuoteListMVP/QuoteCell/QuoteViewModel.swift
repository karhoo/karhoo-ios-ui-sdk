//
//  QuoteViewModel.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
import KarhooSDK

final class QuoteViewModel {
    
    let fleetName: String
    let scheduleCaption: String
    let scheduleMainValue: String
    let carType: String
    let fare: String
    let logoImageURL: String
    let fareType: String
    let showPickUpLabel: Bool
    let pickUpType: String
    let passengerCapacity: String
    let baggageCapacity: String

    /// If this message is not `nil`, it should be displayed
    let freeCancellationMessage: String?

    init(quote: Quote,
         bookingStatus: BookingStatus = KarhooBookingStatus.shared) {
        self.passengerCapacity = "\(quote.vehicle.passengerCapacity)"
        self.baggageCapacity = "\(quote.vehicle.luggageCapacity)"
        self.fleetName = quote.fleet.name
        let bookingDetails = bookingStatus.getBookingDetails()
        let scheduleTexts = QuoteViewModel.scheduleTexts(quote: quote,
                                                         bookingDetails: bookingDetails)
        self.scheduleCaption = scheduleTexts.caption
        self.scheduleMainValue = scheduleTexts.value
        self.carType = quote.vehicle.vehicleClass

        switch quote.serviceLevelAgreements?.serviceCancellation.type {
        case .timeBeforePickup:
            if let freeCancellationMinutes = quote.serviceLevelAgreements?.serviceCancellation.minutes, freeCancellationMinutes > 0 {
                let timeBeforeCancel = TimeFormatter().minutesAndHours(timeInMinutes: freeCancellationMinutes)
                let messageFormat = bookingDetails?.isScheduled == true ? UITexts.Quotes.freeCancellationPrebook : UITexts.Quotes.freeCancellationASAP
                freeCancellationMessage = String(format: messageFormat, timeBeforeCancel)
            } else {
                freeCancellationMessage = nil
            }
        case .beforeDriverEnRoute:
            freeCancellationMessage = UITexts.Quotes.freeCancellationBeforeDriverEnRoute
        default:
            freeCancellationMessage = nil
        }

        switch quote.source {
        case .market: fare =  CurrencyCodeConverter.quoteRangePrice(quote: quote)
        case .fleet: fare = CurrencyCodeConverter.toPriceString(quote: quote)
        }

        self.logoImageURL = quote.fleet.logoUrl
        self.fareType = quote.quoteType.description
        let origin = bookingDetails?.originLocationDetails?.details.type
        self.showPickUpLabel = quote.pickUpType != .default && origin == .airport

        switch quote.pickUpType {
        case .meetAndGreet: pickUpType = UITexts.Bookings.meetAndGreetPickup
        case .curbside: pickUpType = UITexts.Bookings.cubsidePickup
        case .standyBy: pickUpType = UITexts.Bookings.standBy
        default: pickUpType = ""
        }
    }

    private static func scheduleTexts(quote: Quote, bookingDetails: BookingDetails?) -> (caption: String, value: String) {
        if let scheduledDate = bookingDetails?.scheduledDate,
           let originTimeZone = bookingDetails?.originLocationDetails?.timezone() {
            // If the booking is prebooked display only the date + time
            let timeZone = originTimeZone
            let prebookFormatter = KarhooDateFormatter(timeZone: timeZone)
            let dateString = prebookFormatter.display(mediumStyleDate: scheduledDate)
            let timeString = prebookFormatter.display(shortStyleTime: scheduledDate)
            return (dateString, timeString)
        } else {
            // If the booking is ASAP display the ETA
            let etaCaption = UITexts.Generic.etaLong.uppercased()
            let etaMinutes = QtaStringFormatter().qtaString(min: quote.vehicle.qta.lowMinutes,
                                                            max: quote.vehicle.qta.highMinutes)
            return (etaCaption, etaMinutes)
        }
    }
}
