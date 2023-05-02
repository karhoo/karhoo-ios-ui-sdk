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
    case electric, hybrid, wheelchair, childSeat, taxi, executive, luxury
    
    enum CodingKeys: String, CodingKey {
        case childSeat = "child-seat"
    }
    
    var title: String {
        switch self {
        case .electric:
            return UITexts.VehicleTag.electric
        case .hybrid:
            return UITexts.VehicleTag.hybrid
        case .wheelchair:
            return UITexts.VehicleTag.wheelchair
        case .childSeat:
            return UITexts.VehicleTag.childseat
        case .taxi:
            return UITexts.VehicleTag.taxi
        case .executive:
            return UITexts.VehicleTag.executive
        case .luxury:
            return UITexts.VehicleTag.luxury
            
        }
    }
    
    var image: UIImage {
        switch self {
        case .electric:
            return UIImage.uisdkImage("kh_uisdk_electric_tag")
        case .hybrid:
            return UIImage.uisdkImage("kh_uisdk_circle")
        case .wheelchair:
            return UIImage.uisdkImage("kh_uisdk_wheelchair_tag")
        case .childSeat:
            return UIImage.uisdkImage("kh_uisdk_childseat")
        case .taxi:
            return UIImage.uisdkImage("kh_uisdk_taxi")
        case .executive:
            return UIImage.uisdkImage("kh_uisdk_star")
        case .luxury:
            return UIImage.uisdkImage("kh_uisdk_star")
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
            return UIImage.uisdkImage("kh_uisdk_gps_tracking_icon")
        case .flightTracking:
            return UIImage.uisdkImage("kh_uisdk_flight_tracking_icon")
        case .trainTracking:
            return UIImage.uisdkImage("kh_uisdk_train_tracking_icon")
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
    let vehicleType: String
    let vehicleTags: [VehicleTag]
    let fleetCapabilities: [FleetCapabilities]
    let fare: String
    let logoImageURL: String
    var vehicleImageURL: String?
    var vehicleImageAccessibilityText: String?
    var vehicleBadgeImage: UIImage?
    let fareType: String
    let showPickUpLabel: Bool
    let pickUpType: String
    let passengerCapacity: Int?
    let luggageCapacity: Int?
    let isScheduled: Bool

    /// If this message is not `nil`, it should be displayed
    private(set) var freeCancellationMessage: String?

    init(
        quote: Quote,
        journeyDetailsManager: JourneyDetailsManager = KarhooJourneyDetailsManager.shared,
        vehicleRulesProvider: VehicleRulesProvider = KarhooVehicleRulesProvider()
    ) {
        self.passengerCapacity = quote.vehicle.passengerCapacity
        self.luggageCapacity = quote.vehicle.luggageCapacity
        self.fleetName = quote.fleet.name
        self.fleetDescription = quote.fleet.description
        let journeyDetails = journeyDetailsManager.getJourneyDetails()
        let scheduleTexts = QuoteViewModel.getScheduleTexts(quote: quote,
                                                         journeyDetails: journeyDetails)
        self.scheduleCaption = scheduleTexts.caption
        self.scheduleMainValue = scheduleTexts.value
        self.vehicleType = quote.vehicle.getVehicleTypeText()
        self.vehicleTags = quote.vehicle.tags.compactMap { VehicleTag(rawValue: $0) }
        self.fleetCapabilities = quote.fleet.capability.compactMap { FleetCapabilities(rawValue: $0) }

        switch quote.source {
        case .market: fare =  CurrencyCodeConverter.quoteRangePrice(quote: quote)
        case .fleet: fare = CurrencyCodeConverter.toPriceString(quote: quote)
        @unknown default:
            assertionFailure()
            fare =  CurrencyCodeConverter.quoteRangePrice(quote: quote)
        }

        self.logoImageURL = quote.fleet.logoUrl
        self.fareType = quote.quoteType.description
        let origin = journeyDetails?.originLocationDetails?.details.type
        self.showPickUpLabel = quote.pickUpType != .default && origin == .airport
        self.isScheduled = journeyDetails?.isScheduled ?? false
        switch quote.pickUpType {
        case .meetAndGreet: pickUpType = UITexts.Bookings.meetAndGreetPickup
        case .curbside: pickUpType = UITexts.Bookings.cubsidePickup
        case .standyBy: pickUpType = UITexts.Bookings.standBy
        default: pickUpType = ""
        }
        getImageUrl(for: quote, with: vehicleRulesProvider)
        getBadgeImage(for: quote)
        setFreeCancellationMessage(for: quote, and: journeyDetails)
    }
    
    private func setFreeCancellationMessage(for quote: Quote, and journeyDetails: JourneyDetails?) {
        switch quote.serviceLevelAgreements?.serviceCancellation.type {
        case .timeBeforePickup:
            if let freeCancellationMinutes = quote.serviceLevelAgreements?.serviceCancellation.minutes, freeCancellationMinutes > 0 {
                let timeBeforeCancel = TimeFormatter().minutesAndHours(timeInMinutes: freeCancellationMinutes)
                let messageFormat = journeyDetails?.isScheduled == true ? UITexts.Quotes.freeCancellationPrebook : UITexts.Quotes.freeCancellationASAP
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

    private func getImageUrl(for quote: Quote, with provider: VehicleRulesProvider) {
        provider.getRule(for: quote) { [weak self] vehicleImageRule in
            self?.vehicleImageURL = vehicleImageRule?.imagePath
            self?.vehicleImageAccessibilityText = vehicleImageRule?.tags.first ?? quote.vehicle.tags.first ?? quote.vehicle.getVehicleTypeText()
        }
    }

    private static func getScheduleTexts(quote: Quote, journeyDetails: JourneyDetails?) -> (caption: String, value: String) {
        if let scheduledDate = journeyDetails?.scheduledDate,
           let originTimeZone = journeyDetails?.originLocationDetails?.timezone() {
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

    private func getBadgeImage(for quote: Quote) {
        let vehicleTags = quote.vehicle.tags

        var image: UIImage?
        if vehicleTags.contains("economy") {
            image = UIImage.uisdkImage("kh_uisdk_vehicle_badge_economy")
        } else if vehicleTags.contains("electric") {
            image = UIImage.uisdkImage("kh_uisdk_vehicle_badge_electric")
        } else if vehicleTags.contains("hybrid") {
            image = UIImage.uisdkImage("kh_uisdk_vehicle_badge_hybrid")
        }
    
        vehicleBadgeImage = image
    }
}

extension QuoteVehicle {
    func getVehicleTypeText() -> String {
        let tags = self.tags.compactMap { VehicleTag(rawValue: $0) }
        if tags.contains(.executive) {
            return UITexts.QuoteCategory.executive
        }
        if tags.contains(.luxury) {
            return UITexts.VehicleTag.luxury
        }
        return self.localizedVehicleType
    }
}
