//
//  JourneySummaryInfoViewModel.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
  
final class JourneySummaryInfoViewModel {

    public let pickup: String
    public let destination: String
    public let formattedDate: String
    public let vehicleInformation: String
    public let supplierName: String
    public let price: String
    public let priceDescription: String
    public let clientLogo: UIImage

    init(trip: TripInfo) {
        self.clientLogo = KarhooUISDKConfigurationProvider.configuration.logo()
        self.pickup = trip.origin.displayAddress
        self.destination = trip.destination?.displayAddress ?? ""
        self.supplierName = trip.fleetInfo.name

        self.vehicleInformation = trip.vehicle.vehicleClass == "" ?
            "\(trip.vehicle.description): \(trip.vehicle.vehicleLicensePlate)" :
        "\(trip.vehicle.vehicleClass): \(trip.vehicle.vehicleLicensePlate)"

        let dateFormatter = KarhooDateFormatter(timeZone: trip.origin.timezone())
        self.formattedDate = dateFormatter.display(detailStyleDate: trip.dateScheduled)

        if trip.fare.total != 0 {
            self.price = trip.farePrice()
            self.priceDescription = UITexts.TripSummary.totalFare
        } else {
            self.price = trip.quotePrice()
            self.priceDescription = UITexts.TripSummary.quotedPrice
        }
    }
}
