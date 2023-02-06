//
//  ScreenBuilders.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

public protocol ScreenBuilders {
    var addressBuilder: AddressScreenBuilder { get }
    var ridesBuilder: RidesScreenBuilder { get }
    var ridesScreenBuilder: RidesListScreenBuilder { get }
    var rideDetailsScreenBuilder: RideDetailsScreenBuilder { get }
    var bookingScreenBuilder: BookingScreenBuilder { get }
    var bookingConfirmationBuilder: BookingConfirmationBuilder { get }
    var tripScreenBuilder: TripScreenBuilder { get }
    var checkoutScreenBuilder: CheckoutScreenBuilder { get }
}

internal protocol InternalScreenBuilders {
    var tripSummaryScreenBuilder: TripSummaryScreenBuilder { get }
    var datePickerScreenBuilder: DatePickerScreenBuilder { get }
    var popupDialogScreenBuilder: PopupDialogScreenBuilder { get }
    var sideMenuBuilder: SideMenuBuilder { get }
    var tripFeedbackScreenBuilder: TripFeedbackScreenBuilder { get }
    var bottomSheetScreenBuilder: BottomSheetScreenBuilder { get }
}

final class KarhooScreenBuilders: ScreenBuilders, InternalScreenBuilders {

    var popupDialogScreenBuilder: PopupDialogScreenBuilder {
        return PopupDialogViewController.KarhooPopupDialogScreenBuilder()
    }

    var bookingScreenBuilder: BookingScreenBuilder {
        return KarhooBookingScreenBuilder()
    }

    var checkoutScreenBuilder: CheckoutScreenBuilder {
        return checkoutBuilder()
    }

    var datePickerScreenBuilder: DatePickerScreenBuilder {
        return DatePickerViewController.KarhooDatePickerScreenBuilder()
    }

    var tripSummaryScreenBuilder: TripSummaryScreenBuilder {
        return TripSummaryViewController.KarhooTripSummaryScreenBuilder()
    }

    var sideMenuBuilder: SideMenuBuilder {
        return SideMenuViewController.KarhooSideMenuBuilder()
    }

    var tripFeedbackScreenBuilder: TripFeedbackScreenBuilder {
        return KarhooTripFeedbackViewController.KarhooTripFeedbackScreenBuilder()
    }
    
    var bottomSheetScreenBuilder: BottomSheetScreenBuilder {
        return KarhooBottomSheetScreenBuilder()
    }
}

/* default public screen builders */
public extension ScreenBuilders {

    var bookingScreenBuilder: BookingScreenBuilder {
        return KarhooBookingScreenBuilder()
    }

    var bookingConfirmationBuilder: BookingConfirmationBuilder {
        return KarhooBookingConfirmationBuilder()
    }

    var addressBuilder: AddressScreenBuilder {
        return AddressViewController.KarhooAddressScreenBuilder()
    }

    var ridesBuilder: RidesScreenBuilder {
        return RidesViewController.KarhooRidesScreenBuilder()
    }

    var rideDetailsScreenBuilder: RideDetailsScreenBuilder {
        return RideDetailsViewController.KarhooRideDetailsScreenBuilder()
    }

    var ridesScreenBuilder: RidesListScreenBuilder {
        return RidesListViewController.KarhooRidesListScreenBuilder()
    }

    var tripScreenBuilder: TripScreenBuilder {
        return KarhooTripViewController.KarhooTripScreenBuilder()
    }

    var checkoutScreenBuilder: CheckoutScreenBuilder {
        return checkoutBuilder()
    }

    func checkoutBuilder() -> CheckoutScreenBuilder {
        return KarhooCheckoutCoordinator.Builder()
    }
}
