//
//  UITexts.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK

public enum UITexts {

    /* Generics */
    public enum Generic {
        public static let cancel = "Text.Generic.Cancel".localized
        public static let cancelled = "Text.Generic.Cancelled".localized
        public static let ok = "Text.Generic.Ok".localized
        public static let close = "Text.Generic.Close".localized
        public static let yes = "Text.Generic.Yes".localized
        public static let no = "Text.Generic.No".localized
        public static let done = "Text.Generic.Done".localized
        public static let back = "Text.Generic.Back".localized
        public static let error = "Text.Generic.Error".localized
        public static let register = "Text.Generic.Register".localized
        public static let logout = "Text.Generic.Logout".localized
        public static let contact = "Text.Generic.Contact".localized
        public static let bookings = "Text.Generic.Bookings".localized
        public static let payment = "Text.Generic.Payment".localized
        public static let payments = "Text.Generic.Payments".localized
        public static let edit = "Text.Generic.Edit".localized
        public static let destination = "Text.Generic.Destination".localized
        public static let pickup = "Text.Generic.Pickup".localized
        public static let prebook = "Text.Generic.Prebook".localized
        public static let registeringAccountAction = "Text.Generic.RegisterAccountAction".localized
        public static let makingABookingAction = "Text.Generic.MakingBookingAction".localized
        public static let termsAndConditions = "Text.Generic.TermsConditions".localized
        public static let termsOfUse = "Text.Generic.TermsOfUse".localized
        public static let privacyPolicy = "Text.Generic.PrivacyPolicy".localized
        public static let cancellationPolicy = "Text.Generic.CancellationPolicy".localized
        public static let minutes = "Text.Generic.Minutes".localized
        public static let pickupTime = "Text.Generic.PickupTime".localized
        public static let fixed = "Text.Generic.Fixed".localized
        public static let estimated = "Text.Generic.Estimated".localized
        public static let metered = "Text.Generic.Metered".localized
        public static let unknown = "Text.Generic.Unknown".localized
        public static let completed = "Text.Generic.Completed".localized
        public static let requesting = "Text.Generic.Requesting".localized
        public static let status = "Text.Generic.Status".localized
        public static let price = "Text.Generic.Price".localized
        public static let card = "Text.Generic.Card".localized
        public static let reportIssue = "Text.Generic.ReportIssue".localized
        public static let rides = "Text.Generic.Rides".localized
        public static let noMailSetUpMessage = "Text.Generic.NoEmailSetupError".localized
        public static let noCarsAvailable = "Text.Generic.NoCarsAvailable".localized
        public static let gotIt = "Text.Generic.GotIt".localized
        public static let additionalInformation = "Text.Generic.AdditionalInformation".localized
        public static let thanks = "Text.Generic.Thanks".localized
        public static let show = "Text.Generic.Show".localized
        public static let hide = "Text.Generic.Hide".localized
        public static let add = "Text.Generic.Add".localized
        public static let change = "Text.Generic.Change".localized
        public static let submit = "Text.Generic.Submit".localized
        public static let etaLong = "Text.Generic.ETALong".localized
        public static let meetGreet = "Text.Generic.MeetGreet".localized
        public static let estimatedPrice = "Text.Generic.EPrice".localized
        public static let name = "Text.Generic.Name".localized
        public static let surname = "Text.Generic.Surname".localized
        public static let email = "Text.Generic.Email".localized
        public static let phone = "Text.Generic.PhoneNumber".localized
        public static let comment = "Text.Generic.Comment".localized
        public static let commentOptional = "Text.Generic.Comment.Optional".localized
        public static let optional = "Text.Generic.Optional".localized
        public static let errorMessage = "Text.Generic.ErrorMessage".localized
        public static let locale = "Text.Generic.Locale".localized
    }

    public enum GenericTripStatus {
        public static let initialised = "Text.GenericTripStatus.Initialised".localized
        public static let requested = "Text.GenericTripStatus.Requested".localized
        public static let confirmed = "Text.GenericTripStatus.Confirmed".localized
        public static let allocated = "Text.GenericTripStatus.Allocated".localized
        public static let enRoute = "Text.GenericTripStatus.EnRoute".localized
        public static let approaching = "Text.GenericTripStatus.Approaching".localized
        public static let arrived = "Text.GenericTripStatus.Arrived".localized
        public static let passengerOnBoard = "Text.GenericTripStatus.PassengerOnBoard".localized
        public static let completed = "Text.GenericTripStatus.Completed".localized
        public static let cancelled = "Text.GenericTripStatus.Cancelled".localized
        public static let failed = "Text.GenericTripStatus.Failed".localized
        public static let unkown = "Text.GenericTripStatus.Unkown".localized
        public static let incomplete = "Text.GenericTripStatus.Incomplete".localized
        public static let karhooCancelled = "Text.GenericTripStatus.CancelledByKarhoo".localized
        public static let bookerCancelled = "Text.Generic.TripStatus.BookerCancelled".localized
        public static let driverCancelled = "Text.Generic.TripStatus.DriverCancelled".localized
        public static let noDriversAvailable = "Text.Generic.TripStatus.NoDriversAvailable".localized
        public static let driverAllocationDelayTitle = "Text.Generic.TripStatus.DriverAllocationDelay.Title".localized
        public static let driverAllocationDelayMessage = "Text.Generic.TripStatus.DriverAllocationDelay.Message".localized
    }

    /* Address Bar */
    public enum AddressBar {
        public static let addDestination = "Text.AddressBar.AddDestination".localized
        public static let addPickup = "Text.AddressBar.AddPickup".localized
        public static let enterPickup = "Text.AddressBar.EnterPickupLocation".localized
        public static let enterDestination = "Text.AddressSearch.EnterDestinationLocation".localized
    }

    /* User (register / login / user attributes */
    public enum User {
        public static let firstName = "Text.User.FirstName".localized
        public static let lastName = "Text.User.LastName".localized
        public static let email = "Text.User.Email".localized
        public static let countryCode = "Text.User.PhoneCountryCode".localized
        public static let mobilePhone = "Text.User.MobilePhoneNumber".localized
        public static let password = "Text.User.Password".localized
        public static let signupEmailSubscribeCopy = "Text.User.EmailSubscription".localized
        public static let signupPendingMessage = "Text.User.SignupPendingMessage".localized
        public static let forgottenPassword = "Text.User.ForgottenPassword".localized
    }

    /* Errors */
    public enum Errors {
        public static let flightNumberValidatorError = "Text.Error.FlightNumberValidationHint".localized
        public static let noDetailsAvailable = "Text.Error.NoDetails".localized
        public static let somethingWentWrong = "Text.Error.SomethingWentWrong".localized
        public static let cantSendEmail = "Text.Error.Alert.CantSendEmail".localized
        public static let getUserFail = "Text.Error.GetUserFails".localized
        public static let forceUpdateTitle = "Text.Error.Alert.ForceUpdateTitle".localized
        public static let forceUpdateMessage = "Text.Error.Alert.ForceUpdateMessage".localized
        public static let forceUpdateButton = "Text.Error.Alert.ForceUpdateButton".localized
        public static let prebookingWithinTheHour = "Text.Error.PrebookingWithinTheHour".localized
        public static let missingPaymentSDKToken = "Text.Errors.failedToInitialisePaymentSetup".localized
        public static let noResultsFound = "Text.Errors.NoResultsFound".localized
        public static let missingPhoneNumber = "Text.Errors.MissingPhoneNumber".localized
        public static let invalidPhoneNumber = "Text.Errors.InvalidPhoneNumber".localized
        public static let insufficientBalanceForLoyaltyBurning = "Text.Errors.InsufficientBalanceForLoyaltyBurning".localized
        public static let unsupportedCurrency = "Text.Error.UnsupportedCurrency".localized
    }

    /* Payment Error */
    public enum PaymentError {
        public static let paymentAlertTitle = "Text.Error.Payment.Alert.Title".localized
        public static let paymentAlertMessage = "Text.Error.Payment.Alert.Message".localized
        public static let paymentAlertUpdateCard = "Text.Error.Payment.Alert.ButtonUpdateCard".localized
    }

    /* terms conditions construction */
    public enum TermsConditions {
        // 1: action 2: Supplier name, 2: "Terms and Conditions", 3: "Cancellation/Privacy Policy"
        public static let termsConditionFullString = "Text.TermsConditions.FullString".localized
        // 1: "Terms and Conditions", 2: "Privacy Policy", 3: Fleet Name, 4: "Terms and Conditions, 5: "Cancellation Policy"
        public static let bookingTermAndConditionsFullText = "Text.TermsConditions.BookingFullString".localized
        
        public static let karhooTermsLink = "Text.TermsConditions.KarhooTermsLink".localized
        public static let karhooPolicyLink = "Text.TermsConditions.KarhooPolicyLink".localized
        
        public static var termsLink = "Text.TermsConditions.TermsLink".localized
        public static var policyLink = "Text.TermsConditions.PolicyLink".localized
    }

    /* Demand API (Karhoo specific) errors */
    public enum KarhooError {
        public static let K3002 = "Text.KarhooError.K3002".localized // no availability in requested area
        public static let Q0001 = "Text.KarhooError.Q0001".localized // origin
    }
    
    /* Help */
    public enum Help {
        public static var faqLink = "Text.Help.FAQ.Link".localized
        public static var contactUsLink = "Text.Help.ContactUs.Link".localized
    }

    /* Side menu */
    public enum SideMenu {
        public static let signIn = "Text.SideMenu.SignIn".localized
        public static let profile = "Text.SideMenu.Profile".localized
        public static let register = "Text.SideMenu.Register".localized
        public static let signOut = "Text.SideMenu.SignOut".localized
        public static let help = "Text.SideMenu.Help".localized
        public static let feedback = "Text.SideMenu.Feedback".localized
        public static let about = "Text.SideMenu.About".localized
    }

    /* Payment */
    public enum Payment {
        public static let addPaymentMethod = "Text.Payment.AddPaymentMethod".localized
        public static let paymentMethod = "Text.Payment.PaymentMethod".localized
    }

    /* support mail */
    public enum SupportMailMessage {
        public static let feedbackMailMessage = "Text.SupportMailMessage.Feedback".localized
        public static let supportMailReportTrip = "Text.SupportMailMessage.ReportIssue".localized
        public static let feedbackEmailSubject = "Text.SupportMailMessage.FeedbackSubject".localized
        public static let reportIssueEmailSubject = "Text.SupportMailMessage.ReportIssueSubject".localized
        public static let noCoverageEmailSubject = "Text.SupportMailMessage.NoCoverageSubject".localized
        public static let noCoverageEmailBody = "Text.SupportMailMessage.NoCoverageBody".localized
        public static let noCoverageEmailAddress = "Text.SupportMailMessage.SupplierEmail".localized
        public static let supportEmailAddress = "Text.SupportMailMessage.SupportEmail".localized
        public static let feedbackEmailAddress = "Text.SupportMailMessage.FeedbackEmail".localized
    }

    /* Prebook */
    public enum Prebook {
        public static let prebookPickerTitle = "Text.Prebook.PrebookPickupTime".localized
        public static let setPrebookTime = "Text.Prebook.SetPrebook".localized
        // Booking will be made in local time of pickup (timezone-abbreviation)
        public static let timeZoneMessage = "Text.Prebook.TimezoneMessage".localized
    }

    /* Booking */
    public enum Booking {
        public static let bookNow = "Text.Booking.BookNow".localized
        public static let requestCar = "Text.Booking.RequestCar".localized
        public static let requestingCar = "Text.Booking.RequestingCar".localized
        public static let next = "Text.Booking.Next".localized
        public static let requestReceived = "Text.Booking.RequestReceived".localized
        public static let enterDestination = "Text.Booking.EnterDestination".localized
        public static let baseFareExplanation = "Text.Booking.BaseFareExplanation".localized
        public static let baseFare = "Text.Booking.BaseFare".localized
        public static let prebookRideHint = "Text.Booking.PrebookHint".localized
        public static let prebookConfirmed = "Text.Booking.PrebookConfirmed".localized
        public static let prebookConfirmedRideDetails = "Text.Booking.PrebookConfirmed.RideDetails".localized
        public static let prebookConfirmation = "Text.Booking.PrebookConfirmation".localized
        public static let noAvailabilityHeader = "Text.Booking.NoAvailabilityHeader".localized
        public static let noAvailabilityBody = "Text.Booking.NoAvailabilityBody".localized
        public static let noAvailabilityLink = "Text.Booking.NoAvailabilityLink".localized
        public static let guestCheckoutPassengerDetailsTitle = "Text.Booking.GuestCheckoutPassengerDetailsTitle".localized
        public static let guestCheckoutPaymentDetailsTitle = "Text.Booking.GuestCheckoutPaymentDetailsTitle".localized
        public static let guestCheckoutFlightNumberPlaceholder = "Text.Booking.GuestCheckoutFlightNumberPlaceholder".localized
        public static let estimatedInfoBox = "Text.Booking.EstimatedInfoBox".localized
        public static let meteredInfoBox = "Text.Booking.MeteredInfoBox".localized
        public static let fixedInfoBox = "Text.Booking.FixedInfoBox".localized
        public static let learnMore = "Text.Booking.LearnMore".localized
        public static let passenger = "Text.Booking.Passenger".localized
        public static let maximumPassengers = "Text.Booking.MaximumPassengers".localized
        public static let maximumLuggages = "Text.Booking.MaximumLuggages".localized
        public static let gpsTracking = "Text.Booking.GPSTracking".localized
        public static let trainTracking = "Text.Booking.TrainTracking".localized
        public static let flightTracking = "Text.Booking.FlightTracking".localized
        public static let quoteExpiredTitle = "Text.Booking.QuoteExpired".localized
        public static let quoteExpiredMessage = "Text.Booking.QuoteExpiredMessage".localized
    }

    public enum Availability {
        public static let allCategory = "Text.Availability.AllCategory".localized
        public static let noQuotesInSelectedCategory = "Text.Availability.NoQuotesInSelectedCategory".localized
        public static let noQuotesForSelectedParameters = "Text.Availability.NoQuotesForSelectedParameters".localized
    }

    public enum TripAllocation {
        public static let findingYourRide = "Text.TripAllocation.FindingYourRide".localized
        public static let allocatingTripOne = "Text.TripAllocation.AllocatingTripOne".localized
        public static let allocatingTripTwo = "Text.TripAllocation.AllocatingTripTwo".localized
        public static let cancelling = "Text.TripAllocation.Cancelling".localized
        public static let cancelInstruction = "Text.TripAllocation.CancelInstruction".localized
    }
    
    public enum PassengerDetails {
        public static let title = "Text.Booking.PassengerDetails.Title".localized
        public static let subtitle = "Text.Booking.PassengerDetails.Subtitle".localized
        public static let firstName = "Text.Booking.PassengerDetails.FirstName".localized
        public static let lastName = "Text.Booking.PassengerDetails.LastName".localized
        public static let email = "Text.Booking.PassengerDetails.Email".localized
        public static let mobilePhone = "Text.Booking.PassengerDetails.MobilePhone".localized
        public static let saveAction = "Text.Booking.PassengerDetails.SaveAction".localized
        public static let add = "Text.Booking.PassengerDetails.Add".localized
    }
    
    public enum QuoteCategory {
        public static let electric = "Text.QuoteCategory.Electric".localized
        public static let mpv = "Text.QuoteCategory.MPV".localized
        public static let saloon = "Text.QuoteCategory.Saloon".localized
        public static let exec = "Text.QuoteCategory.Exec".localized
        public static let executive = "Text.QuoteCategory.Executive".localized
        public static let moto = "Text.QuoteCategory.Moto".localized
        public static let motorcycle = "Text.QuoteCategory.Motorcycle".localized
        public static let taxi = "Text.QuoteCategory.Taxi".localized
    }
    
    public enum VehicleClass {
        public static let saloon = "Text.VehicleClass.Saloon".localized
        public static let taxi = "Text.VehicleClass.Taxi".localized
        public static let mpv = "Text.VehicleClass.MPV".localized
        public static let exec = "Text.VehicleClass.Exec".localized
        public static let executive = "Text.VehicleClass.Executive".localized
        public static let moto = "Text.VehicleClass.Moto".localized
        public static let motorcycle = "Text.VehicleClass.Motorcycle".localized
        public static let electric = "Text.VehicleClass.Electric".localized
    }
    
    public enum VehicleType {
        public static let moto = "Text.VehicleType.Moto".localized
        public static let standard = "Text.VehicleType.Standard".localized
        public static let mpv = "Text.VehicleType.MPV".localized
        public static let bus = "Text.VehicleType.Bus".localized
    }
    
    public enum VehicleTag {
        public static let electric = "Text.VehicleTag.Electric".localized
        public static let hybrid = "Text.VehicleTag.Hybrid".localized
        public static let wheelchair = "Text.VehicleTag.Wheelchair".localized
        public static let childseat = "Text.VehicleTag.Childseat".localized
        public static let taxi = "Text.VehicleTag.Taxi".localized
        public static let executive = "Text.VehicleTag.Executive".localized
    }
    
    public enum CountryCodeSelection {
        public static let title = "Text.Booking.CountryCodeSelection.Title".localized
        public static let search = "Text.Booking.CountryCodeSelection.Search".localized
    }

    /* Trip */
    public enum Trip {
        public static let tripStatusUnkown = "Text.Trip.Unkown".localized
        public static let tripStatusRequested = "Text.Trip.Requested".localized
        public static let tripStatusConfirmed = "Text.Trip.Confirmed".localized
        public static let tripStatusDriverEnRoute = "Text.Trip.DriverEnRoute".localized

        public static let tripStatusDriverArrived = "Text.Trip.DriverArrived".localized
        public static let tripStatusPassengerOnboard = "Text.Trip.PassengerOnBoard".localized
        public static let tripStatusCompleted = "Text.Trip.Completed".localized
        public static let tripStatusCancelledByUser = "Text.Trip.CancelledByUser".localized
        public static let tripStatusCancelledByDispatch = "Text.Trip.CancelledByDispatch".localized
        
        public static let tripCancelRide = "Text.Trip.CancelRide".localized
        public static let tripCancelledByDispatchAlertTitle = "Text.Trip.CancelledByDispatch.AlertTitle".localized
        public static let tripCancelledByDispatchAlertMessage = "Text.Trip.CancelledByDispatch.AlertMessage".localized
        public static let tripCancelBookingConfirmationAlertTitle = "Text.Trip.CancelBookingConfirmation.Alert.Title".localized
        public static let tripCancelBookingConfirmationAlertMessage = "Text.Trip.CancelBookingConfirmation.Alert.Message".localized
        public static let tripCancelBookingFailedAlertTitle = "Text.Trip.CancelBookingFailed.AlertTitle".localized
        public static let tripCancelBookingFailedAlertMessage = "Text.Trip.CancelBookingFailed.AlertMessage".localized
        public static let tripCancelBookingFailedAlertCallFleetButton = "Text.Trip.CancelBookingFailed.AlertCallFleetButton".localized
        public static let tripCancellingActivityIndicatorText = "Text.Trip.ActivityIndicator.Cancelling".localized
        public static let tripContactDriver = "Text.Trip.CallDriver".localized
        public static let tripContactFleet = "Text.Trip.CallFleet".localized
        public static let tripRideOptions = "Text.Trip.RideOptions".localized
        public static let noDriversAvailableTitle = "Text.Trip.NoDriversAvailable.AlertTitle".localized
        public static let noDriversAvailableMessage = "Text.Trip.NoDriversAvailable.AlertMessage".localized
        public static let arrival = "Text.Trip.Arrival".localized
        public static let karhooCancelledAlertTitle = "Text.Trip.KarhooCancelled.AlertTitle".localized
        public static let karhooCancelledAlertMessage = "Text.Trip.KarhooCancelled.AlertMessage".localized

        public static let trackTripAlertTitle = "Text.Bookings.TrackTrip.AlertTitle".localized
        public static let trackTripAlertMessage = "Text.Bookings.TrackTrip.AlertMessage".localized
        public static let trackTripAlertAction = "Text.Bookings.TrackTrip.TrackAction".localized
        public static let trackTripAlertDismissAction = "Text.Bookings.TrackTrip.DismissAction".localized
    }

    public enum TripSummary {
        public static let tripSummary = "Text.TripSummary.TripSummary".localized
        public static let paymentSummary = "Text.TripSummary.PaymentSummary".localized
        public static let bookReturnRide = "Text.TripSummary.BookReturnRide".localized
        public static let date = "Text.TripSummary.Date".localized
        public static let fleet = "Text.TripSummary.Fleet".localized
        public static let vehicle = "Text.TripSummary.Vehicle".localized
        public static let totalFare = "Text.TripSummary.TotalFare".localized
        public static let quotedPrice = "Text.TripSummary.QuotedPrice".localized
    }

    public enum TripRating {
        static let thankYouConfirmation = "Text.TripRating.Confirmation".localized
        static let ratingTitleMessage = "Text.TripRating.Title".localized
        static let extraFeedbackButton = "Text.TripRating.ExtraFeedback".localized
        static let quoteFeedbackTitle = "Text.FeedbackView.quote".localized
        static let prePobFeedbackTitle = "Text.FeedbackView.pre_pob".localized
        static let pobFeedbackTitle = "Text.FeedbackView.pob".localized
        static let appFeedbackTitle = "Text.FeedbackView.app".localized
        static let addCommentPlaceholder = "Text.FeedbackView.addComment".localized
        static let confirmationMessage = "Text.FeedbackView.confirmation".localized
    }

    public enum Bookings {
        static let noTrips = "Text.Bookings.NoTrips".localized
        static let noTripsBookedMessage = "Text.Bookings.NoTripsBookedMessage".localized
        static let bookATrip = "Text.Bookings.BookATrip".localized
        static let newRide = "Text.Bookings.NewRide".localized
        static let trackDriver = "Text.Bookings.TrackDriver".localized
        static let contactDriver = "Text.Bookings.ContactDriver".localized
        static let contactFleet = "Text.Bookings.ContactFleet".localized
        static let trackTrip = "Text.Bookings.TrackTrip".localized
        static let cancelRide = "Text.Bookings.CancelRide".localized
        static let reportIssue = "Text.Bookings.ReportIssue".localized
        static let rebookRide = "Text.Bookings.RebookRide".localized
        static let quote = "Text.Bookings.Quote".localized
        static let price = "Text.Bookings.Price".localized
        static let couldNotLoadTrips = "Text.Bookings.CouldNotLoadTrips".localized
        static let priceCancelled = "Text.Bookings.Price.Cancelled".localized
        public static let cancellationSuccessAlertTitle = "Text.Bookings.Alert.CancellationSuccess.Title".localized
        public static let cancellationSuccessAlertMessage = "Text.Bookings.Alert.CancellationSuccess.Message".localized
        public static let cancellationFeeCharge = "Text.Bookings.Alert.CancellationFee.Charge".localized
        public static let cancellationFeeContinue = "Text.Bookings.Alert.CancellationFee.Continue".localized
        static let past = "Text.Bookings.Past".localized
        static let upcoming = "Text.Bookings.Upcoming".localized
        static let sortEta = "Text.Bookings.eta".localized
        static let sortPrice = "Text.Bookings.price".localized
        static let meetAndGreetPickup = PickUpType.meetAndGreet.rawValue.localized
        static let cubsidePickup = PickUpType.curbside.rawValue.localized
        static let standBy = PickUpType.standyBy.rawValue.localized
    }
    
    public enum TrackingLinks {
        static let sandboxLink = "Text.TrackingLink.sandbox".localized
        static let productionLink = "Text.TrackingLink.production".localized
        static let stagingLink = "Text.TrackingLink.staging".localized
    }

    public enum Airport {
        static let flightNumber = "Text.Airport.FlightNumber".localized
        static let bookingMessage = "Text.Airport.HelpfulMessage".localized
        static let airportPickup = "Text.Airport.Pickup".localized
        static let addFlightDetails = "Text.Airport.AddFlightDetails".localized
    }

    public enum AddressScreen {
        static let noRecentAddresses = "Text.Address.NoRecentAddress".localized
        static let noResultsFound = "Text.Errors.NoResultsFound".localized
        static let setOnMap = "Text.Address.SetOnMap".localized
        static let currentLocation = "Text.Address.CurrentLocation".localized
    }
    
    public enum Quotes {
        static let freeCancellationPrebook = "Text.Quote.FreeCancellationPrebook".localized
        static let freeCancellationASAP = "Text.Quote.FreeCancellationASAP".localized
        static let freeCancellationAndKeyword = "Text.Quote.FreeCancellationAndKeyword".localized
        static let freeCancellationBeforeDriverEnRoute = "Text.Quote.FreeCancellationBeforeDriverEnRoute".localized
        static let feesAndTaxesIncluded = "Text.Quote.FeesAndTaxesIncluded".localized
    }
    
    public enum Loyalty {
        static let title = "Text.Loyalty.Title".localized
        static let pointsEarnedForTrip = "Text.Loyalty.PointsEarnedForTrip".localized
        static let pointsBurnedForTrip = "Text.Loyalty.PointsBurnedForTrip".localized
        static let info = "Text.Loyalty.Info".localized
        static let noAllowedToBurnPoints = "Text.Loyalty.BurnNotAllowed".localized
        static let balanceTitle = "Text.Loyalty.BalanceTitle".localized
    }
}

extension KarhooError {
    var localizedMessage: String {
        return code.localized != code ? code.localized : userMessage
    }
}

public extension String {
    var localized: String {
        if NSLocalizedString(self, bundle: Bundle.main, comment: "") != self {
            return NSLocalizedString(self, bundle: Bundle.main, comment: "")
        } else {
            return NSLocalizedString(self, bundle: .current, comment: "")
        }
    }
    
    func firstLetterUppercased() -> String {
        guard let firstLetter = self.first?.uppercased() else {
            return self
        }
        return firstLetter + self.dropFirst()
    }
    
    func removePrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix)
        else {
            return self
        }
        return String(self.dropFirst(prefix.count))
    }
}
