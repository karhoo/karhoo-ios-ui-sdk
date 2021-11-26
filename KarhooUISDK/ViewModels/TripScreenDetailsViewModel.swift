//
//  TripScreenDetailsViewModel.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

struct TripScreenDetailsViewModel {

    let driverName: String
    let vehicleDescription: String
    let vehicleLicensePlate: String
    let driverRegulatoryLicenseNumber: String
    let driverPhotoUrl: String
    let trip: TripInfo

    init(trip: TripInfo) {
        self.trip = trip

        self.driverName = "\(trip.vehicle.driver.firstName) \(trip.vehicle.driver.lastName)"
        self.vehicleDescription = trip.vehicle.description
        self.vehicleLicensePlate = trip.vehicle.vehicleLicensePlate
        self.driverRegulatoryLicenseNumber = trip.vehicle.driver.licenseNumber
        self.driverPhotoUrl = trip.vehicle.driver.photoUrl
    }
}
