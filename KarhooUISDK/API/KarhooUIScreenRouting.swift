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
    func tripScreen() -> TripScreenBuilder
    func checkout() -> CheckoutScreenBuilder
    func bookingConfirmation() -> BookingConfirmationBuilder
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

    public func tripScreen() -> TripScreenBuilder {
        return routing.tripScreenBuilder
    }

    public func checkout() -> CheckoutScreenBuilder {
        return routing.checkoutScreenBuilder
    }

    public func bookingConfirmation() -> BookingConfirmationBuilder {
        return routing.bookingConfirmationBuilder
    }
    internal func datePicker() -> DatePickerScreenBuilder {
        return internalRouting.datePickerScreenBuilder
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
    
    internal func bottomSheetScreen() -> BottomSheetScreenBuilder {
        return internalRouting.bottomSheetScreenBuilder
    }
}
