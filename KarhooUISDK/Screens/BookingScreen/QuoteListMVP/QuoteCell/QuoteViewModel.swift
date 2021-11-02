//
//  QuoteViewModel.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
import KarhooSDK

enum VehicleTag: String {
    case electric, hybrid, wheelchair, childSeat, taxi, executive
    
    enum CodingKeys: String, CodingKey {
        case childSeat = "child-seat"
    }
    
    var title: String {
        switch self {
        case .electric:
            return UITexts.VehicleTags.electric
        case .hybrid:
            return UITexts.VehicleTags.hybrid
        case .wheelchair:
            return UITexts.VehicleTags.wheelchair
        case .childSeat:
            return UITexts.VehicleTags.childseat
        case .taxi:
            return UITexts.VehicleTags.taxi
        case .executive:
            return UITexts.VehicleTags.executive
        }
    }
    
    var image: UIImage {
        switch self {
        case .electric:
            return UIImage.uisdkImage("electric")
        case .hybrid:
            return UIImage.uisdkImage("circle")
        case .wheelchair:
            return UIImage.uisdkImage("wheelchair")
        case .childSeat:
            return UIImage.uisdkImage("childseat")
        case .taxi:
            return UIImage.uisdkImage("taxi")
        case .executive:
            return UIImage.uisdkImage("star")
        }
    }
}

enum FleetCapabilities: String {
    case gpsTracking, flightTracking, trainTracking
    
    enum CodingKeys: String, CodingKey {
        case gpsTracking = "gps_tracking"
        case flightTracking = "flight_tracking"
        case trainTracking = "train_tracking"
    }
    
    var title: String {
        switch self {
        case .gpsTracking:
            return UITexts.Booking.gpsTracking
        case .flightTracking:
            return UITexts.Booking.flightTracking
        case .trainTracking:
            return UITexts.Booking.trainTracking
        }
    }
    
    var image: UIImage {
        switch self {
        case .gpsTracking:
            return UIImage.uisdkImage("gpsTrackingIcon")
        case .flightTracking:
            return UIImage.uisdkImage("flightTrackingIcon")
        case .trainTracking:
            return UIImage.uisdkImage("trainTrackingIcon")
        }
    }
    
    init?(rawValue: String) {
        guard let key = CodingKeys(rawValue: rawValue) else {
            return nil
        }
        switch key {
        case .gpsTracking:
            self = .gpsTracking
        case .flightTracking:
            self = .flightTracking
        case .trainTracking:
            self = .trainTracking
        }
    }
}

final class QuoteViewModel {
    
    let fleetName: String
    let fleetDescription: String
    let scheduleCaption: String
    let scheduleMainValue: String
    let carType: String
    let vehicleTags: [VehicleTag]
    let fleetCapabilities: [FleetCapabilities]
    let fare: String
    let logoImageURL: String
    let fareType: String
    let showPickUpLabel: Bool
    let pickUpType: String
    let passengerCapacity: Int
    let baggageCapacity: Int

    /// If this message is not `nil`, it should be displayed
    let freeCancellationMessage: String?

    init(quote: Quote,
         bookingStatus: BookingStatus = KarhooBookingStatus.shared) {
        self.passengerCapacity = quote.vehicle.passengerCapacity
        self.baggageCapacity = quote.vehicle.luggageCapacity
        self.fleetName = quote.fleet.name
        self.fleetDescription = quote.fleet.description
        let bookingDetails = bookingStatus.getBookingDetails()
        let scheduleTexts = QuoteViewModel.scheduleTexts(quote: quote,
                                                         bookingDetails: bookingDetails)
        self.scheduleCaption = scheduleTexts.caption
        self.scheduleMainValue = scheduleTexts.value
        // TODO: to be reverted later to localized carType - vehicleClass is deprecated
        self.carType = quote.vehicle.localizedVehicleClass
        self.vehicleTags = quote.vehicle.tags.compactMap { VehicleTag(rawValue: $0) }
        self.fleetCapabilities = quote.fleet.capability.compactMap { FleetCapabilities(rawValue: $0) }

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
