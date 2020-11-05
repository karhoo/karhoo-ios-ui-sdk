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
    var flightDetailsScreenBuilder: FlightDetailsScreenBuilder { get }
    var journeyScreenBuilder: TripScreenBuilder { get }
    var bookingRequestScreenBuilder: BookingRequestScreenBuilder { get }
}

internal protocol InternalScreenBuilders {
    var journeySummaryScreenBuilder: JourneySummaryScreenBuilder { get }
    var paymentScreenBuilder: PaymentScreenBuilder { get }
    var prebookConfirmationScreenBuilder: PrebookConfirmationScreenBuilder { get }
    var datePickerScreenBuilder: DatePickerScreenBuilder { get }
    var popupDialogScreenBuilder: PopupDialogScreenBuilder { get }
    var sideMenuBuilder: SideMenuBuilder { get }
    var tripFeedbackScreenBuilder: TripFeedbackScreenBuilder { get }
}

final class KarhooScreenBuilders: ScreenBuilders, InternalScreenBuilders {

    var popupDialogScreenBuilder: PopupDialogScreenBuilder {
        return PopupDialogViewController.KarhooPopupDialogScreenBuilder()
    }

    var bookingScreenBuilder: BookingScreenBuilder {
        return KarhooBookingScreenBuilder()
    }

    var bookingRequestScreenBuilder: BookingRequestScreenBuilder {
        return bookingRequestBuilder()
    }

    var datePickerScreenBuilder: DatePickerScreenBuilder {
        return DatePickerViewController.KarhooDatePickerScreenBuilder()
    }

    var prebookConfirmationScreenBuilder: PrebookConfirmationScreenBuilder {
        return KarhooPrebookConfirmationViewController.KarhooPrebookConfirmationScreenBuilder()
    }

    var paymentScreenBuilder: PaymentScreenBuilder {
        return BraintreePaymentScreenBuilder()
    }

    var journeySummaryScreenBuilder: JourneySummaryScreenBuilder {
        return TripSummaryViewController.KarhooJourneySummaryScreenBuilder()
    }

    var sideMenuBuilder: SideMenuBuilder {
        return SideMenuViewController.KarhooSideMenuBuilder()
    }

    var tripFeedbackScreenBuilder: TripFeedbackScreenBuilder {
        return KarhooTripFeedbackViewController.KarhooTripFeedbackScreenBuilder()
    }
}

/* default public screen builders */
public extension ScreenBuilders {

    var bookingScreenBuilder: BookingScreenBuilder {
        return KarhooBookingScreenBuilder()
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

    var flightDetailsScreenBuilder: FlightDetailsScreenBuilder {
        return FlightDetailsViewController.KarhooFlightDetailsScreenBuilder()
    }

    var journeyScreenBuilder: TripScreenBuilder {
        return KarhooTripViewController.KarhooJourneyScreenBuilder()
    }

    var bookingRequestScreenBuilder: BookingRequestScreenBuilder {
        return bookingRequestBuilder()
    }

    func bookingRequestBuilder() -> BookingRequestScreenBuilder {
        switch Karhoo.configuration.authenticationMethod() {
        case .guest(settings: _), .tokenExchange: return FormBookingRequestViewController.Builder()
        case .karhooUser: return KarhooBookingRequestViewController.KarhooBookingRequestScreenBuilder()
        }
    }
}
