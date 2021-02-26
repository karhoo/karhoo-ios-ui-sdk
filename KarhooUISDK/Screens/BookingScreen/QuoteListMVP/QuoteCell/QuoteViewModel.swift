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
    
    public let fleetName: String
    public let eta: String
    public let carType: String
    public let fare: String
    public let logoImageURL: String
    public let fareType: String
    public let showPickUpLabel: Bool
    public let pickUpType: String
    public let passengerCapacity: String
    public let baggageCapacity: String
    public let freeCancellationMinutes: Int
    public let showCancellationInfo: Bool

    init(quote: Quote,
         bookingStatus: BookingStatus = KarhooBookingStatus.shared) {
        self.passengerCapacity = "\(quote.vehicle.passengerCapacity)"
        self.baggageCapacity = "\(quote.vehicle.luggageCapacity)"
        self.fleetName = quote.fleet.name
        self.eta = QtaStringFormatter().qtaString(min: quote.vehicle.qta.lowMinutes,
                                                  max: quote.vehicle.qta.highMinutes)
        self.carType = quote.vehicle.vehicleClass
        self.freeCancellationMinutes = quote.serviceLevelAgreements?.serviceCancellation.minutes ?? 0
        self.showCancellationInfo = freeCancellationMinutes > 0

        switch quote.source {
        case .market: fare =  CurrencyCodeConverter.quoteRangePrice(quote: quote)
        case .fleet: fare = CurrencyCodeConverter.toPriceString(quote: quote)
        }

        self.logoImageURL = quote.fleet.logoUrl
        self.fareType = quote.quoteType.description
        let origin = bookingStatus.getBookingDetails()?.originLocationDetails?.details.type
        self.showPickUpLabel = quote.pickUpType != .default && origin == .airport

        switch quote.pickUpType {
        case .meetAndGreet: pickUpType = UITexts.Bookings.meetAndGreetPickup
        case .curbside: pickUpType = UITexts.Bookings.cubsidePickup
        case .standyBy: pickUpType = UITexts.Bookings.standBy
        default: pickUpType = ""
        }
    }
}
