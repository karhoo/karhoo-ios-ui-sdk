//
//  TripInfoUtility.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK

public struct TripInfoUtility {

    public static func isCancelled(trip: TripInfo) -> Bool {
        return [.bookerCancelled,
               .driverCancelled,
               .noDriversAvailable,
               .karhooCancelled].contains(trip.state)
    }

    public static func canCancel(trip: TripInfo) -> Bool {
        return [.requested,
                .confirmed,
                .driverEnRoute,
                .arrived].contains(trip.state)
    }

    public static func canTrackAndContactDriver(trip: TripInfo) -> Bool {
        return canTrackDriver(trip: trip) && canContactDriver(trip: trip)
    }

    public static func canContactDriver(trip: TripInfo) -> Bool {
        return trip.vehicle.driver.phoneNumber.isEmpty == false
    }

    public static func canTrackDriver(trip: TripInfo) -> Bool {
        return [.driverEnRoute, .arrived, .passengerOnBoard].contains(trip.state)
    }

    public static func preDriverAllocation(trip: TripInfo) -> Bool {
        return [.requested, .confirmed].contains(trip.state)
    }

    public static func isAirportBooking(_ bookingDetails: JourneyDetails) -> Bool {
        return bookingDetails.originLocationDetails?.details.type == .airport ||
               bookingDetails.destinationLocationDetails?.details.type == .airport
    }

    public static func short(tripState: TripState) -> String {
        let tripStatuses: [TripState: String] = [.requested: UITexts.GenericTripStatus.requested,
                                                 .bookerCancelled: UITexts.GenericTripStatus.cancelled,
                                                 .driverCancelled: UITexts.GenericTripStatus.cancelled,
                                                 .karhooCancelled: UITexts.GenericTripStatus.cancelled,
                                                 .noDriversAvailable: UITexts.GenericTripStatus.cancelled,
                                                 .confirmed: UITexts.GenericTripStatus.confirmed,
                                                 .driverEnRoute: UITexts.GenericTripStatus.enRoute,
                                                 .arrived: UITexts.GenericTripStatus.arrived,
                                                 .passengerOnBoard: UITexts.GenericTripStatus.passengerOnBoard,
                                                 .completed: UITexts.GenericTripStatus.completed,
                                                 .unknown: UITexts.GenericTripStatus.unkown,
                                                 .incomplete: UITexts.GenericTripStatus.incomplete]
        return tripStatuses[tripState] ?? ""
    }

    public static func longDescription(trip: TripInfo) -> String {
        let requestedState = String(format: UITexts.Trip.tripStatusRequested,
                trip.fleetInfo.name)

        let tripStatuses: [TripState: String] = [.unknown: UITexts.Trip.tripStatusUnkown,
                                                 .requested: requestedState,
                                                 .confirmed: UITexts.Trip.tripStatusConfirmed,
                                                 .driverEnRoute: UITexts.Trip.tripStatusDriverEnRoute,
                                                 .arrived: UITexts.Trip.tripStatusDriverArrived,
                                                 .passengerOnBoard: UITexts.Trip.tripStatusPassengerOnboard,
                                                 .completed: UITexts.Trip.tripStatusCompleted,
                                                 .driverCancelled: UITexts.Trip.tripStatusCancelledByDispatch,
                                                 .bookerCancelled: UITexts.Trip.tripStatusCancelledByUser]
        return tripStatuses[trip.state] ?? ""
    }
}
