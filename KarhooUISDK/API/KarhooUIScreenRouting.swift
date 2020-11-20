//
//  KarhooUIScreenRouting.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public protocol Routing {
    func address() -> AddressScreenBuilder
    func rides() -> RidesScreenBuilder
    func ridesList() -> RidesListScreenBuilder
    func rideDetails() -> RideDetailsScreenBuilder
    func booking() -> BookingScreenBuilder
    func flightDetails() -> FlightDetailsScreenBuilder
    func tripScreen() -> TripScreenBuilder
    func bookingRequest() -> BookingRequestScreenBuilder
}

public final class UISDKScreenRouting: Routing {

    public static let `default` = UISDKScreenRouting()
    private(set) var routing: ScreenBuilders = KarhooScreenBuilders()
    private var internalRouting: InternalScreenBuilders = KarhooScreenBuilders()

    private init() {}

    func set(routing: ScreenBuilders) {
        self.routing = routing
    }

    public func address() -> AddressScreenBuilder {
       return routing.addressBuilder
    }

    public func rides() -> RidesScreenBuilder {
        return routing.ridesBuilder
    }

    public func ridesList() -> RidesListScreenBuilder {
        return routing.ridesScreenBuilder
    }

    public func rideDetails() -> RideDetailsScreenBuilder {
        return routing.rideDetailsScreenBuilder
    }

    public func booking() -> BookingScreenBuilder {
        return routing.bookingScreenBuilder
    }

    public func flightDetails() -> FlightDetailsScreenBuilder {
        return routing.flightDetailsScreenBuilder
    }

    public func tripScreen() -> TripScreenBuilder {
        return routing.tripScreenBuilder
    }

    public func bookingRequest() -> BookingRequestScreenBuilder {
        return routing.bookingRequestScreenBuilder
    }

    public func paymentScreen() -> PaymentScreenBuilder {
        return internalRouting.paymentScreenBuilder
    }

    internal func datePicker() -> DatePickerScreenBuilder {
        return internalRouting.datePickerScreenBuilder
    }

    internal func prebookConfirmation() -> PrebookConfirmationScreenBuilder {
        return internalRouting.prebookConfirmationScreenBuilder
    }

    internal func tripSummary() -> TripSummaryScreenBuilder {
        return internalRouting.tripSummaryScreenBuilder
    }

    internal func sideMenu() -> SideMenuBuilder {
        return internalRouting.sideMenuBuilder
    }

    internal func popUpDialog() -> PopupDialogScreenBuilder {
        return internalRouting.popupDialogScreenBuilder
    }

    internal func tripFeedbackScreen() -> TripFeedbackScreenBuilder {
        return internalRouting.tripFeedbackScreenBuilder
    }
}
