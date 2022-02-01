//
//  TripDetailsViewModel.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import KarhooSDK

final class TripDetailsViewModel {

    public let pickup: String
    public let destination: String
    public let accessibilityDate: String
    public let formattedDate: String
    public let vehicleInformation: String
    public let supplierName: String
    public let supplierLogoStringURL: String
    public let showMeetingPoint: Bool
    public let meetingPointText: String
    
    init(trip: TripInfo) {
        self.pickup = trip.origin.displayAddress
        self.destination = trip.destination?.displayAddress ?? ""
        self.supplierName = trip.fleetInfo.name
        self.supplierLogoStringURL = trip.fleetInfo.logoUrl
        let dateFormatter = KarhooDateFormatter(timeZone: trip.origin.timezone())
        self.accessibilityDate = dateFormatter.display(fullDate: trip.dateScheduled)
        self.formattedDate = dateFormatter.display(detailStyleDate: trip.dateScheduled)
        switch trip.state {
        case .driverEnRoute, .arrived, .passengerOnBoard, .completed:
            self.vehicleInformation = "\(trip.vehicle.description) \(trip.vehicle.vehicleLicensePlate)"
        default:
            self.vehicleInformation = "\(trip.vehicle.description)"
        }
        
        let meetingPointType = trip.meetingPoint?.type
        self.showMeetingPoint = meetingPointType != nil && meetingPointType != .default && meetingPointType != .notSet

        switch meetingPointType {
        case .meetAndGreet?: meetingPointText = UITexts.Bookings.meetAndGreetPickup
        case .curbSide?: meetingPointText = UITexts.Bookings.cubsidePickup
        case .standBy?: meetingPointText = UITexts.Bookings.standBy
        default: meetingPointText = ""
        }
    }
}
