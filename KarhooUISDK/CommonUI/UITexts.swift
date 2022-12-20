//
//  UITexts.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//
// swiftlint:disable file_length

import Foundation
import KarhooSDK

public enum UITexts {

    /* Generics */
    public enum Generic {
        public static let cancel = "kh_uisdk_cancel".localized
        public static let ok = "kh_uisdk_ok".localized
        public static let close = "kh_uisdk_close".localized
        public static let yes = "kh_uisdk_yes".localized
        public static let no = "kh_uisdk_no".localized
        public static let back = "kh_uisdk_back".localized
        public static let error = "kh_uisdk_error".localized
        public static let register = "kh_uisdk_register".localized
        public static let bookings = "kh_uisdk_bookings".localized
        public static let payment = "kh_uisdk_payment".localized
        public static let payments = "kh_uisdk_payments".localized
        public static let edit = "kh_uisdk_edit".localized
        public static let minutes = "kh_uisdk_min".localized
        public static let pickupTime = "kh_uisdk_pickup_time".localized
        public static let fixed = "kh_uisdk_fixed_fare".localized
        public static let estimated = "kh_uisdk_estimated_fare".localized
        public static let metered = "kh_uisdk_metered".localized
        public static let requesting = "kh_uisdk_requesting".localized
        public static let status = "kh_uisdk_status".localized
        public static let price = "kh_uisdk_price".localized
        public static let card = "kh_uisdk_card".localized
        public static let reportIssue = "kh_uisdk_report_issue".localized
        public static let rides = "kh_uisdk_rides".localized
        public static let save = "kh_uisdk_save".localized
        public static let noMailSetUpMessage = "kh_uisdk_no_email_setup_error".localized
        public static let noCarsAvailable = "kh_uisdk_no_cars_available".localized
        public static let gotIt = "kh_uisdk_got_it".localized
        public static let thanks = "kh_uisdk_thanks".localized
        public static let submit = "kh_uisdk_submit".localized
        public static let etaLong = "kh_uisdk_estimated_arrival_time".localized
        public static let meetGreet = "kh_uisdk_pickup_type_meet_and_greet".localized
        public static let estimatedPrice = "kh_uisdk_estimated_fare".localized
        public static let errorMessage = "kh_uisdk_something_went_wrong".localized
        public static let locale = "kh_uisdk_locale".localized
        public static let checked = "kh_uisdk_checked".localized
        public static let unchecked = "kh_uisdk_unchecked".localized
        public static let checkout = "kh_uisdk_booking_checkout_title".localized
    }

    public enum QuoteCell {
        public static let details = "kh_uisdk_quote_cell_details".localized
        public static let driverArrival = "kh_uisdk_driver_arrival".localized
    }

    public enum GenericTripStatus {
        public static let requested = "kh_uisdk_ride_state_requested".localized
        public static let confirmed = "kh_uisdk_ride_state_confirmed".localized
        public static let enRoute = "kh_uisdk_ride_state_der".localized
        public static let arrived = "kh_uisdk_ride_state_arrived".localized
        public static let passengerOnBoard = "kh_uisdk_ride_state_pob".localized
        public static let completed = "kh_uisdk_ride_state_completed".localized
        public static let cancelled = "kh_uisdk_ride_state_cancelled".localized
        public static let driverAllocationDelayTitle = "kh_uisdk_allocation_delay_title".localized
        public static let driverAllocationDelayMessage = "kh_uisdk_allocation_delay_text".localized
    }

    /* Address Bar */
    public enum AddressBar {
        public static let destinationTitle = "kh_uisdk_address_picker_destination_title".localized
        public static let pickupTitle = "kh_uisdk_address_picker_pickup_title".localized
        public static let prebook = "kh_uisdk_address_picker_prebook".localized

        public static let addDestination = "kh_uisdk_address_picker_dropoff_booking".localized
        public static let addPickup = "kh_uisdk_address_picker_add_pickup".localized
        public static let enterPickup = "kh_uisdk_address_picker_enter_pickup".localized
        public static let enterDestination = "kh_uisdk_address_picker_enter_destination".localized
    }

    /* User (register / login / user attributes */
    public enum User {
        public static let firstName = "kh_uisdk_first_name_hint".localized
        public static let lastName = "kh_uisdk_last_name_hint".localized
        public static let email = "kh_uisdk_email_hint".localized
        public static let mobilePhone = "kh_uisdk_mobile_phone_number_hint".localized
        public static let signupEmailSubscribeCopy = "kh_uisdk_signup_email_subscribe_copy".localized
        public static let signupPendingMessage = "kh_uisdk_signup_pending_message".localized
        public static let forgottenPassword = "kh_uisdk_forgotten_password".localized
        public static let commentOptional = "kh_uisdk_additional_comments".localized
    }

    /* Errors */
    public enum Errors {
        public static let flightNumberValidatorError = "kh_uisdk_errors_flight_number_validator_error".localized
        public static let noDetailsAvailable = "kh_uisdk_something_went_wrong".localized
        public static let somethingWentWrong = "kh_uisdk_something_went_wrong".localized
        public static let cantSendEmail = "kh_uisdk_errors_cant_send_email".localized
        public static let getUserFail = "kh_uisdk_errors_get_user_fail".localized
        public static let forceUpdateTitle = "kh_uisdk_errors_force_update_title".localized
        public static let forceUpdateMessage = "kh_uisdk_errors_force_update_message".localized
        public static let forceUpdateButton = "kh_uisdk_errors_force_update_button".localized
        public static let prebookingWithinTheHour = "kh_uisdk_errors_prebooking_within_the_hour".localized
        public static let missingPaymentSDKToken = "kh_uisdk_errors_missing_payment_sdk_token".localized
        public static let noResultsFound = "kh_uisdk_results_empty".localized
        public static let missingPhoneNumber = "kh_uisdk_invalid_empty_field".localized
        public static let invalidPhoneNumber = "kh_uisdk_invalid_phone_number".localized
        public static let insufficientBalanceForLoyaltyBurning = "kh_uisdk_loyalty_pre_auth_not_enough_points".localized
        public static let unsupportedCurrency = "kh_uisdk_loyalty_unsupported_currency".localized
        public static let unknownLoyaltyError = "kh_uisdk_loyalty_unknown_error".localized
        public static let loyaltyModeNotEligibleForPreAuth = "kh_uisdk_loyalty_not_eligible_for_pre_auth".localized

        // Quote List errors
        static let errorNoAvailabilityForTheRequestTimeTitle = "kh_uisdk_quotes_error_no_availability_title".localized
        static let errorNoAvailabilityForTheRequestTimeMessage = "kh_uisdk_quotes_error_no_availability_subtitle".localized
        static let errorPickupAndDestinationSameTitle = "kh_uisdk_quotes_error_similar_addresses_title".localized
        static let errorPickupAndDestinationSameMessage = "kh_uisdk_quotes_error_similar_addresses_subtitle".localized
        static let errorNoAvailabilityInRequestedAreaTitle = "kh_uisdk_quotes_error_no_coverage_title".localized
        static let errorNoResultsForFilterTitle = "kh_uisdk_quotes_error_no_results_after_filter_title".localized
        static let errorNoResultsForFilterMessage = "kh_uisdk_quotes_error_no_results_after_filter_subtitle".localized
        static let errorNoAvailabilityInRequestedAreaContactUsLinkText = "kh_uisdk_contact_us".localized
        static let errorNoAvailabilityInRequestedAreaContactUsFullText = "kh_uisdk_quotes_error_no_coverage_subtitle".localized
        static let errorDestinationOrOriginEmptyTitle = "kh_uisdk_quotes_error_missing_addresses_title".localized
        static let errorDestinationOrOriginEmptyMessage = "kh_uisdk_quotes_error_missing_addresses_subtitle".localized

    }

    /* Payment Error */
    public enum PaymentError {
        public static let paymentAlertTitle = "kh_uisdk_payment_issue".localized
        public static let paymentAlertMessage = "kh_uisdk_payment_issue_message".localized
        public static let paymentAlertUpdateCard = "kh_uisdk_payment_payment_alert_update_card".localized
        public static let noDetailsMessage = "kh_uisdk_something_went_wrong_select_another_quote".localized
    }

    /* terms conditions construction */
    public enum TermsConditions {
        // 1: action 2: Supplier name, 2: "Terms and Conditions", 3: "Cancellation/Privacy Policy"
        public static let termsConditionFullString = "kh_uisdk_terms_condition_full_string".localized
        // 1: "Terms and Conditions", 2: "Privacy Policy", 3: Fleet Name, 4: "Terms and Conditions, 5: "Cancellation Policy"
        public static let bookingTermAndConditionsFullText = "kh_uisdk_booking_terms".localized
        
        public static let karhooTermsLink = "kh_uisdk_karhoo_general_terms_url".localized
        public static let karhooPolicyLink = "kh_uisdk_karhoo_privacy_policy_url".localized
        
        public static var termsLink = "kh_uisdk_karhoo_general_terms_url".localized
        public static var policyLink = "kh_uisdk_karhoo_privacy_policy_url".localized
        public static let registeringAccountAction = "kh_uisdk_terms_and_conditions_register_account_action".localized
        public static let termsAndConditions = "kh_uisdk_label_fleet_terms_and_conditions".localized
        public static let termsOfUse = "kh_uisdk_booking_terms_and_conditions".localized
        public static let privacyPolicy = "kh_uisdk_karhoo_privacy_policy".localized
        public static let cancellationPolicy = "kh_uisdk_label_fleet_cancellation_policy".localized

    }

    /* Demand API (Karhoo specific) errors */
    public enum KarhooError {
        public static let K3002 = "kh_uisdk_quotes_error_no_results_found".localized // no availability in requested area
        public static let Q0001 = "kh_uisdk_Q0001".localized // origin
    }

    /* Side menu */
    public enum SideMenu {
        public static let signIn = "kh_uisdk_sign_in".localized
        public static let profile = "kh_uisdk_profile".localized
        public static let register = "kh_uisdk_register".localized
        public static let signOut = "kh_uisdk_sign_out".localized
        public static let help = "kh_uisdk_help".localized
        public static let feedback = "kh_uisdk_feedback".localized
        public static let about = "kh_uisdk_about".localized
    }
    
    public enum Help {
        public static let faqLink = "kh_uisdk_faq_link".localized
        public static let contactUsLink = "kh_uisdk_contact_us_link".localized
    }

    /* Payment */
    public enum Payment {
        public static let addPaymentMethod = "kh_uisdk_booking_checkout_add_payment_method".localized
        public static let paymentMethod = "kh_uisdk_card".localized
    }

    /* support mail */
    public enum SupportMailMessage {
        public static let feedbackMailMessage = "kh_uisdk_email_info".localized
        public static let supportMailReportTrip = "kh_uisdk_email_report_issue_message".localized
        public static let feedbackEmailSubject = "kh_uisdk_feedback".localized
        public static let reportIssueEmailSubject = "kh_uisdk_feedback_title".localized
        public static let noCoverageEmailSubject = "kh_uisdk_fleet_recommendation_subject".localized
        public static let noCoverageEmailBody = "kh_uisdk_fleet_recommendation_body".localized
        public static let noCoverageEmailAddress = "kh_uisdk_supplier_email".localized
        public static let supportEmailAddress = "kh_uisdk_support_email".localized
        public static let feedbackEmailAddress = "kh_uisdk_feedback_email".localized
    }

    /* Prebook */
    public enum Prebook {
        public static let prebookPickerTitle = "kh_uisdk_prebook_picker_title".localized
        public static let setPrebookTime = "kh_uisdk_set_prebook_time".localized
        public static let timeZoneMessage = "kh_uisdk_prebook_timezone_title".localized
    }

    /* Booking */
    public enum Booking {
        public static let next = "kh_uisdk_next".localized
        public static let bookNow = "kh_uisdk_book_now".localized
        public static let requestCar = "kh_uisdk_request_car".localized
        public static let requestingCar = "kh_uisdk_requesting_car".localized
        public static let requestReceived = "kh_uisdk_request_received".localized
        public static let enterDestination = "kh_uisdk_enter_destination".localized
        public static let baseFareExplanation = "kh_uisdk_base_fare_explanation".localized
        public static let baseFare = "kh_uisdk_base".localized
        public static let prebookRideHint = "kh_uisdk_prebook_picker_title".localized
        public static let prebookConfirmed = "kh_uisdk_prebook_confirmed".localized
        public static let prebookConfirmedRideDetails = "kh_uisdk_ride_details".localized
        public static let prebookConfirmation = "kh_uisdk_prebook_confirmation".localized
        public static let noAvailabilityHeader = "kh_uisdk_quotes_no_availability".localized
        public static let noAvailabilityBody = "kh_uisdk_no_availability_body".localized
        public static let noAvailabilityLink = "kh_uisdk_no_availability_link".localized
        public static let guestCheckoutPassengerDetailsTitle = "kh_uisdk_passenger_details".localized
        public static let guestCheckoutPaymentDetailsTitle = "kh_uisdk_guest_checkout_payment_details_title".localized
        public static let guestCheckoutFlightNumberPlaceholder = "kh_uisdk_flight_number".localized
        public static let estimatedInfoBox = "kh_uisdk_price_info_text_estimated".localized
        public static let meteredInfoBox = "kh_uisdk_price_info_text_metered".localized
        public static let fixedInfoBox = "kh_uisdk_price_info_text_fixed".localized
        public static let learnMore = "kh_uisdk_quote_learn_more".localized
        public static let passenger = "kh_uisdk_booking_checkout_passenger".localized
        public static let maximumPassengers = "kh_uisdk_passengers_max".localized
        public static let maximumLuggages = "kh_uisdk_baggage_max".localized
        public static let gpsTracking = "kh_uisdk_filter_gps_tracking".localized
        public static let trainTracking = "kh_uisdk_filter_train_tracking".localized
        public static let flightTracking = "kh_uisdk_filter_fight_tracking".localized
        public static let quoteExpiredTitle = "kh_uisdk_offer_expired".localized
        public static let quoteExpiredMessage = "kh_uisdk_offer_expired_text".localized
        public static let legalNotice = "kh_uisdk_legal_notice_label".localized
        public static let legalNoticeLink = "kh_uisdk_legal_notice_link".localized
        public static let legalNoticeText = "kh_uisdk_legal_notice_text".localized
        public static let legalNoticeTitle = "kh_uisdk_legal_notice_title".localized
        public static let noLocationPermissionTitle = "kh_uisdk_no_location_permission_title".localized
        public static let noLocationPermissionMessage = "kh_uisdk_no_location_permission_message".localized
        public static let noLocationPermissionConfirm = "kh_uisdk_settings".localized
    }

    public enum Availability {
        public static let allCategory = "kh_uisdk_filter_all".localized
        public static let noQuotesInSelectedCategory = "kh_uisdk_no_quotes_in_selected_category".localized
        public static let noQuotesForSelectedParameters = "kh_uisdk_K3002".localized
    }

    public enum TripAllocation {
        public static let findingYourRide = "kh_uisdk_finding_your_ride".localized
        public static let allocatingTripOne = "kh_uisdk_allocating_trip_one".localized
        public static let allocatingTripTwo = "kh_uisdk_allocating_trip_two".localized
        public static let cancelling = "kh_uisdk_cancelling_ride".localized
        public static let cancelInstruction = "kh_uisdk_cancelling".localized
    }
    
    public enum PassengerDetails {
        public static let title = "kh_uisdk_booking_checkout_passenger".localized
        public static let subtitle = "kh_uisdk_passenger_details_subtitle".localized
        public static let saveAction = "kh_uisdk_save".localized
        public static let add = "kh_uisdk_passenger_details_add_passenger".localized
    }
    
    public enum QuoteCategory {
        public static let electric = "kh_uisdk_electric".localized
        public static let mpv = "kh_uisdk_mpv".localized
        public static let saloon = "kh_uisdk_vehicle_standard".localized
        public static let exec = "kh_uisdk_exec".localized
        public static let executive = "kh_uisdk_filter_executive".localized
        public static let moto = "kh_uisdk_moto".localized
        public static let motorcycle = "kh_uisdk_moto".localized
        public static let taxi = "kh_uisdk_taxi".localized
    }

    public enum QuoteFilterCategory {
        public static let vehicleType = "kh_uisdk_filter_vehicle_types".localized
        public static let vehicleClass = "kh_uisdk_filter_vehicle_class".localized
        public static let vehicleExtras = "kh_uisdk_filter_vehicle_extras".localized
        public static let ecoFriendly = "kh_uisdk_filter_eco_friendly".localized
        public static let fleetCapabilities = "kh_uisdk_filter_fleet_capabilities".localized
        public static let quoteTypes = "kh_uisdk_filter_quote_types".localized
        public static let serviceAgreements = "kh_uisdk_filter_service_agreements".localized
    }
    
    public enum VehicleClass {
        public static let saloon = "kh_uisdk_vehicle_standard".localized
        public static let taxi = "kh_uisdk_taxi".localized
        public static let mpv = "kh_uisdk_mpv".localized
        public static let exec = "kh_uisdk_exec".localized
        public static let luxury = "kh_uisdk_filter_luxury".localized
        public static let moto = "kh_uisdk_moto".localized
        public static let motorcycle = "kh_uisdk_moto".localized
        public static let electric = "kh_uisdk_electric".localized
    }
    
    public enum VehicleType {
        public static let moto = "kh_uisdk_moto".localized
        public static let standard = "kh_uisdk_vehicle_standard".localized
        public static let mpv = "kh_uisdk_mpv".localized
        public static let bus = "kh_uisdk_vehicle_bus".localized
    }
    
    public enum VehicleTag {
        public static let electric = "kh_uisdk_electric".localized
        public static let hybrid = "kh_uisdk_filter_hybrid".localized
        public static let wheelchair = "kh_uisdk_filter_wheelchair".localized
        public static let childseat = "kh_uisdk_filter_child_seat".localized
        public static let taxi = "kh_uisdk_taxi".localized
        public static let executive = "kh_uisdk_filter_executive".localized
        public static let luxury = "kh_uisdk_filter_luxury".localized
    }

    public enum FleetCapabilities {
        public static let flightTracking = "kh_uisdk_filter_fight_tracking".localized
        public static let trainTracking = "kh_uisdk_filter_train_tracking".localized
        public static let gpsTracking = "kh_uisdk_filter_gps_tracking".localized
        public static let driverDetails = "kh_uisdk_filter_driver_details".localized
        public static let vehicleDetails = "kh_uisdk_filter_vehicle_details".localized
    }
    
    public enum CountryCodeSelection {
        public static let search = "kh_uisdk_country_search".localized
    }

    /* Trip */
    public enum Trip {
        public static let tripStatusRequested = "kh_uisdk_trip_status_requested".localized
        public static let tripStatusConfirmed = "kh_uisdk_trip_status_confirmed".localized
        public static let tripStatusDriverEnRoute = "kh_uisdk_trip_status_driver_en_route".localized

        public static let tripStatusDriverArrived = "kh_uisdk_trip_status_driver_arrived".localized
        public static let tripStatusPassengerOnboard = "kh_uisdk_pass_on_board".localized
        public static let tripStatusCompleted = "kh_uisdk_trip_status_completed".localized
        public static let tripStatusCancelledByUser = "kh_uisdk_trip_status_cancelled_by_user".localized
        public static let tripStatusCancelledByDispatch = "kh_uisdk_trip_status_cancelled_by_dispatch".localized
        
        public static let tripCancelRide = "kh_uisdk_cancel_ride".localized
        public static let tripCancelledByDispatchAlertTitle = "kh_uisdk_trip_cancelled_by_dispatch_alert_title".localized
        public static let tripCancelledByDispatchAlertMessage = "kh_uisdk_trip_cancelled_by_dispatch_alert_message".localized
        public static let tripCancelBookingConfirmationAlertTitle = "kh_uisdk_cancel_your_ride".localized
        public static let tripCancelBookingFailedAlertTitle = "kh_uisdk_difficulties_cancelling_title".localized
        public static let tripCancelBookingFailedAlertMessage = "kh_uisdk_difficulties_cancelling_message".localized
        public static let tripCancelBookingFailedAlertCallFleetButton = "kh_uisdk_contact_fleet".localized
        public static let tripCancellingActivityIndicatorText = "kh_uisdk_cancelling_ride".localized
        public static let tripContactDriver = "kh_uisdk_contact_driver".localized
        public static let tripContactFleet = "kh_uisdk_contact_fleet".localized
        public static let tripRideOptions = "kh_uisdk_trip_ride_options".localized
        public static let noDriversAvailableTitle = "kh_uisdk_booking_failed".localized
        public static let noDriversAvailableMessage = "kh_uisdk_booking_failed_body".localized
        public static let arrival = "kh_uisdk_arrival".localized
        public static let karhooCancelledAlertTitle = "kh_uisdk_karhoo_cancelled_alert_title".localized
        public static let karhooCancelledAlertMessage = "kh_uisdk_karhoo_cancelled_alert_message".localized

        public static let trackTripAlertTitle = "kh_uisdk_track_trip_alert_title".localized
        public static let trackTripAlertMessage = "kh_uisdk_track_trip_alert_message".localized
        public static let trackTripAlertAction = "kh_uisdk_yes".localized
        public static let trackTripAlertDismissAction = "kh_uisdk_no".localized
    }

    public enum TripSummary {
        public static let addToCalendar = "kh_uisdk_trip_summary_add_to_calendar".localized
        public static let addedToCalendar = "kh_uisdk_trip_summary_added_to_calendar".localized
        public static let calendarEventTitle = "kh_uisdk_trip_summary_calendar_event_title".localized
        public static let trainNumber = "kh_uisdk_trip_summary_train_number".localized
        public static let flightNumber = "kh_uisdk_trip_summary_flight_number".localized
        public static let tripSummary = "kh_uisdk_trip_summary".localized
        public static let paymentSummary = "kh_uisdk_payment_summary".localized
        public static let bookReturnRide = "kh_uisdk_book_return_ride".localized
        public static let date = "kh_uisdk_date".localized
        public static let fleet = "kh_uisdk_fleet".localized
        public static let vehicle = "kh_uisdk_vehicle".localized
        public static let totalFare = "kh_uisdk_total_fare".localized
        public static let quotedPrice = "kh_uisdk_quoted_price".localized
    }

    public enum TripRating {
        static let thankYouConfirmation = "kh_uisdk_rating_submitted".localized
        static let ratingTitleMessage = "kh_uisdk_rate_trip_label".localized
        static let extraFeedbackButton = "kh_uisdk_feedback_title".localized
        static let quoteFeedbackTitle = "kh_uisdk_question_one".localized
        static let prePobFeedbackTitle = "kh_uisdk_question_two".localized
        static let pobFeedbackTitle = "kh_uisdk_question_three".localized
        static let appFeedbackTitle = "kh_uisdk_question_four".localized
        static let addCommentPlaceholder = "kh_uisdk_add_comment_placeholder".localized
    }

    public enum Bookings {
        static let noTrips = "kh_uisdk_no_trips".localized
        static let noTripsBookedMessage = "kh_uisdk_past_rides_empty".localized
        static let newRide = "kh_uisdk_new_ride".localized
        static let trackDriver = "kh_uisdk_track_driver".localized
        static let contactDriver = "kh_uisdk_contact_driver".localized
        static let contactFleet = "kh_uisdk_contact_fleet".localized
        static let trackTrip = "kh_uisdk_track_trip".localized
        static let cancelRide = "kh_uisdk_cancel_ride".localized
        static let reportIssue = "kh_uisdk_report_issue".localized
        static let rebookRide = "kh_uisdk_rebook_ride".localized
        static let quote = "kh_uisdk_quote".localized
        static let price = "kh_uisdk_price".localized
        static let couldNotLoadTrips = "kh_uisdk_could_not_load_trips".localized
        static let priceCancelled = "kh_uisdk_cancelled".localized
        public static let cancellationSuccessAlertTitle = "kh_uisdk_cancel_ride_successful".localized
        public static let cancellationSuccessAlertMessage = "kh_uisdk_cancel_ride_successful_message".localized
        public static let cancellationFeeCharge = "kh_uisdk_you_may_be_charged".localized
        public static let cancellationFeeContinue = "kh_uisdk_would_you_like_to_proceed".localized
        static let past = "kh_uisdk_title_page_past".localized
        static let upcoming = "kh_uisdk_title_page_upcoming".localized
        static let sortEta = "kh_uisdk_eta".localized
        static let sortPrice = "kh_uisdk_price".localized
        static let meetAndGreetPickup = PickUpType.meetAndGreet.rawValue.localized
        static let cubsidePickup = PickUpType.curbside.rawValue.localized
        static let standBy = PickUpType.standyBy.rawValue.localized
    }
    
    public enum TrackingLinks {
        static let sandboxLink = "kh_uisdk_sandbox_link".localized
        static let productionLink = "kh_uisdk_production_link".localized
        static let stagingLink = "kh_uisdk_staging_link".localized
    }

    public enum Airport {
        static let flightNumber = "kh_uisdk_flight_number".localized
        static let bookingMessage = "kh_uisdk_airport_booking_message".localized
    }

    public enum AddressScreen {
        static let noRecentAddresses = "kh_uisdk_recents_empty".localized
        static let noResultsFound = "kh_uisdk_results_empty".localized
        static let setOnMap = "kh_uisdk_set_on_map".localized
        static let currentLocation = "kh_uisdk_current_location".localized
    }
    
    public enum Quotes {
        static let freeCancellation = "kh_uisdk_filter_free_cancellation".localized
        static let freeCancellationPrebook = "kh_uisdk_quote_cancellation_before_pickup_ios".localized
        static let freeCancellationASAP = "kh_uisdk_free_cancellation_asap".localized
        static let freeCancellationAndKeyword = "kh_uisdk_quote_cancellation_and_keyword".localized
        static let freeCancellationBeforeDriverEnRoute = "kh_uisdk_quote_cancellation_before_driver_departure".localized
        static let freeWaitingTime = "kh_uisdk_filter_free_waiting_time".localized
        static let feesAndTaxesIncluded = "kh_uisdk_fees_and_taxes_included".localized
        static let result = "kh_uisdk_result".localized
        static let results = "kh_uisdk_results_ios".localized
        static let driverArrivalTime = "kh_uisdk_driver_arrival".localized
        static let filter = "kh_uisdk_filter".localized
        static let filterPageResults = "kh_uisdk_filter_page_results".localized
        static let resetFilter = "kh_uisdk_reset_filter".localized
        static let filtersPassengers = "kh_uisdk_filter_passengers".localized
        static let filtersLuggages = "kh_uisdk_filter_luggages".localized
        static let sortBy = "kh_uisdk_sort_by".localized
    }
    
    public enum Loyalty {
        static let loyaltyPointsRemovedInfo = "kh_uisdk_loyalty_info_remove_points".localized
        static let loyaltyPointsAddInfo = "kh_uisdk_loyalty_info_add_points".localized
        static let title = "kh_uisdk_loyalty_title".localized
        static let burnTitle = "kh_uisdk_loyalty_use_points_title".localized
        static let pointsEarnedForTrip = "kh_uisdk_loyalty_points_earned_for_trip".localized
        static let burnOnSubtitle = "kh_uisdk_loyalty_use_points_on_subtitle".localized
        static let burnOffSubtitle = "kh_uisdk_loyalty_use_points_off_subtitle".localized
        static let info = "kh_uisdk_loyalty_info".localized
        static let noAllowedToBurnPoints = "kh_uisdk_loyalty_pre_auth_not_allowed_to_burn".localized
        static let balanceTitle = "kh_uisdk_loyalty_balance_title".localized
        static let or = "kh_uisdk_loyalty_separator".localized
    }
}

extension KarhooError {
    var localizedMessage: String {
        let translationPrefix = "kh_uisdk_"
        let translationsKey = translationPrefix + code
        return translationsKey.localized != translationsKey ? translationsKey.localized : userMessage
    }
    
    var localizedAdyenMessage: String {
        let translationPrefix = "kh_uisdk_adyen_payment_error_"
        let translationsKey = translationPrefix + code
        return translationsKey.localized != translationsKey ? translationsKey.localized : userMessage
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
