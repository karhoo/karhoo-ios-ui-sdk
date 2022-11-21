//
//  NibStrings.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

final class NibStrings: UIView {

    @IBOutlet var sideMenuSignInString: [UILabel]?
    @IBOutlet var sideMenuRegisterString: [UILabel]?
    @IBOutlet var sideMenuHelpString: [UILabel]?
    @IBOutlet var sideMenuFeedbackString: [UILabel]?
    @IBOutlet var sideMenuSignOutString: [UILabel]?
    @IBOutlet var sideMenuRidesString: [UILabel]?
    @IBOutlet var sideMenuPaymentString: [UILabel]?
    @IBOutlet var sideMenuProfileString: [UILabel]?
    @IBOutlet var sideMenuAboutString: [UILabel]?

    @IBOutlet var navBarTitleRegister: [UINavigationBar]?
    @IBOutlet var navBarTitleLogin: [UINavigationBar]?
    @IBOutlet var navBarCancelButton: [UIBarButtonItem]?
    @IBOutlet var navBarCloseButton: [UIBarButtonItem]?
    @IBOutlet var navBarEditButton: [UIBarButtonItem]?
    @IBOutlet var navBarBookingsButton: [UIBarButtonItem]?
    @IBOutlet var navBarTitlePayments: [UINavigationBar]?

    @IBOutlet var addressBarPrebookLabel: [UILabel]?

    @IBOutlet var registerEmailSubscriptionLabel: [UILabel]?

    @IBOutlet var datePickerTitle: [UILabel]?
    @IBOutlet var datePickerSetTime: [UILabel]?

    @IBOutlet var bookingRequestFixed: [UILabel]?

    @IBOutlet var tripAllocationCancelInstructionLabel: [UILabel]?
    @IBOutlet var tripAllocationCancellingLabel: [UILabel]?

    @IBOutlet var tripCancelRide: [UILabel]?
    @IBOutlet var tripContactDriver: [UILabel]?
    @IBOutlet var tripRideOptions: [UILabel]?
    @IBOutlet var tripContactFleet: [UILabel]?
    @IBOutlet var tripInitialRequestingString: [UILabel]?
    @IBOutlet var tripArrivalString: [UILabel]?
    @IBOutlet var bookingDetailStatusString: [UILabel]?
    @IBOutlet var bookingDetailPriceSrtring: [UILabel]?
    @IBOutlet var bookingDetailCardString: [UILabel]?
    @IBOutlet var bookingDetailReportIssueString: [UILabel]?
    @IBOutlet var bookingEmptyNoTripsTitleString: [UILabel]?
    @IBOutlet var bookingEmptyNoTripsMessageString: [UILabel]?
    @IBOutlet var bookingNoCarsFoundOverlay: [UILabel]?
    @IBOutlet var bookingEnterDestinationOverlay: [UILabel]?

    @IBOutlet var airportBookingMessageString: [UILabel]?

    @IBOutlet var bookingsListPastString: [UILabel]?
    @IBOutlet var bookingsListUpcomingString: [UILabel]?

    @IBOutlet var tripSummaryDateString: [UILabel]?
    @IBOutlet var tripSummaryFleetString: [UILabel]?
    @IBOutlet var tripSummaryVehicleString: [UILabel]?
    @IBOutlet var tripSummaryTotalFareString: [UILabel]?
    @IBOutlet var tripSummaryBookReturnRideString: [UILabel]?

    @IBOutlet var navigationBarItemRidesString: [UILabel]?

    @IBOutlet var tripMetaViewStatusString: [UILabel]?

    @IBOutlet var loginScreenForgottenPasswordString: [UILabel]?

    @IBOutlet var tripCancelRideButton: [UIButton]?

    @IBOutlet var addressViewSetOnMapString: [UILabel]?

    override func awakeFromNib() {
        setup()
    }

    func setup() {
        tripCancelRideButton?.forEach({ button in
            button.setTitle(UITexts.Trip.tripCancelRide, for: .normal)
        })

        setValue(UITexts.SideMenu.signIn, forKeyPath: "sideMenuSignInString.text")
        setValue(UITexts.SideMenu.register, forKeyPath: "sideMenuRegisterString.text")
        setValue(UITexts.SideMenu.help, forKeyPath: "sideMenuHelpString.text")
        setValue(UITexts.SideMenu.feedback, forKeyPath: "sideMenuFeedbackString.text")
        setValue(UITexts.SideMenu.signOut, forKeyPath: "sideMenuSignOutString.text")
        setValue(UITexts.SideMenu.profile, forKeyPath: "sideMenuProfileString.text")
        setValue(UITexts.SideMenu.about, forKeyPath: "sideMenuAboutString.text")
        setValue(UITexts.Generic.rides, forKeyPath: "sideMenuRidesString.text")
        setValue(UITexts.Generic.payment, forKeyPath: "sideMenuPaymentString.text")

        setValue(UITexts.Generic.register, forKeyPath: "navBarTitleRegister.topItem.title")
        setValue(UITexts.Generic.cancel, forKeyPath: "navBarCancelButton.title")
        setValue(UITexts.Generic.close, forKeyPath: "navBarCloseButton.title")
        setValue(UITexts.Generic.bookings, forKeyPath: "navBarBookingsButton.title")
        setValue(UITexts.Generic.payments, forKeyPath: "navBarTitlePayments.topItem.title")
        setValue(UITexts.AddressBar.prebook, forKeyPath: "addressBarPrebookLabel.text")

        setValue(UITexts.User.signupEmailSubscribeCopy, forKeyPath: "registerEmailSubscriptionLabel.text")

        setValue(UITexts.Prebook.prebookPickerTitle, forKeyPath: "datePickerTitle.text")
        setValue(UITexts.Prebook.setPrebookTime, forKeyPath: "datePickerSetTime.text")
        setValue(UITexts.Generic.fixed, forKeyPath: "bookingRequestFixed.text")

        setValue(UITexts.Trip.tripRideOptions, forKeyPath: "tripRideOptions.text")
        setValue(UITexts.Trip.tripCancelRide, forKeyPath: "tripCancelRide.text")
        setValue(UITexts.Trip.tripContactFleet, forKeyPath: "tripContactFleet.text")
        setValue(UITexts.Trip.tripContactDriver, forKeyPath: "tripContactDriver.text")
        setValue(UITexts.Trip.arrival, forKeyPath: "tripArrivalString.text")
        setValue(UITexts.Generic.requesting, forKeyPath: "tripInitialRequestingString.text")
        setValue(UITexts.Generic.status, forKeyPath: "bookingDetailStatusString.text")
        setValue(UITexts.Generic.price, forKeyPath: "bookingDetailPriceSrtring.text")
        setValue(UITexts.Generic.card, forKeyPath: "bookingDetailCardString.text")
        setValue(UITexts.Generic.reportIssue, forKeyPath: "bookingDetailReportIssueString.text")
        setValue(UITexts.Bookings.noTrips, forKeyPath: "bookingEmptyNoTripsTitleString.text")
        setValue(UITexts.Bookings.noTripsBookedMessage, forKeyPath: "bookingEmptyNoTripsMessageString.text")
        setValue(UITexts.Generic.noCarsAvailable, forKeyPath: "bookingNoCarsFoundOverlay.text")
        setValue(UITexts.Booking.enterDestination, forKeyPath: "bookingEnterDestinationOverlay.text")

        setValue(UITexts.Airport.bookingMessage, forKeyPath: "airportBookingMessageString.text")

        setValue(UITexts.Bookings.past, forKeyPath: "bookingsListPastString.text")
        setValue(UITexts.Bookings.upcoming, forKeyPath: "bookingsListUpcomingString.text")

        setValue(UITexts.TripSummary.date, forKeyPath: "tripSummaryDateString.text")
        setValue(UITexts.TripSummary.fleet, forKeyPath: "tripSummaryFleetString.text")
        setValue(UITexts.TripSummary.vehicle, forKeyPath: "tripSummaryVehicleString.text")
        setValue(UITexts.TripSummary.totalFare, forKeyPath: "tripSummaryTotalFareString.text")
        setValue(UITexts.TripSummary.bookReturnRide, forKeyPath: "tripSummaryBookReturnRideString.text")

        setValue(UITexts.Generic.rides, forKeyPath: "navigationBarItemRidesString.text")

        setValue(UITexts.Generic.status, forKeyPath: "tripMetaViewStatusString.text")

        setValue(UITexts.User.forgottenPassword, forKeyPath: "loginScreenForgottenPasswordString.text")

        setValue(UITexts.TripAllocation.cancelling, forKeyPath: "tripAllocationCancellingLabel.text")
        setValue(UITexts.TripAllocation.cancelInstruction, forKeyPath: "tripAllocationCancelInstructionLabel.text")

        setValue(UITexts.AddressScreen.setOnMap, forKeyPath: "addressViewSetOnMapString.text")
    }
}
