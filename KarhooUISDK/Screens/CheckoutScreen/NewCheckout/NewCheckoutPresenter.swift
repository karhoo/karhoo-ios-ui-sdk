//
//  NewCheckoutPresenter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 05/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit
import SwiftUI
import Combine

enum NewCheckoutState {
    /// Screen is locked and user's interactions are disabled. Used for crucial data loading (like payment confirmation)
    case loading
    /// UI is enabled but some data's missing in order to proceed with booking, so user needs to provide them.
    case gatheringInfo
    /// UI is enabled and all data's in place. Scene is waiting for user's confirmation.
    case readyToBook
}

final class KarhooNewCheckoutViewModel: ObservableObject {

    // MARK: - Dependencies

    private let quoteValidityWorker: QuoteValidityWorker
    private let tripService: TripService
    private let userService: UserService
    private let analytics: Analytics
    private let sdkConfiguration: KarhooUISDKConfiguration
    private let paymentsWorker = KarhooNewCheckoutPaymentAndBookingWorker()
    private let dateFormatter: DateFormatterType
    private let vehicleRuleProvider: VehicleRulesProvider
    
    // MARK: - Sub view models

    var passangerDetailsViewModel: PassengerDetailsCellViewModel
    var trainNumberCellViewModel: TrainNumberCellViewModel
    var flightNumberCellViewModel: FlightNumberCellViewModel
    var commentCellViewModel: CommentCellViewModel
    var termsConditionsViewModel: KarhooTermsConditionsViewModel
    var legalNoticeViewModel: KarhooLegalNoticeViewModel!

    private let router: NewCheckoutRouter

    // MARK: - Properties

    private var cancellables: Set<AnyCancellable> = []

    private(set) var passengerDetails: PassengerDetails!
    private(set) var trip: TripInfo? // TODO: set value for trip ‼️
    private let journeyDetails: JourneyDetails
    private let bookingMetadata: [String: Any]?
    private var comments: String?
    private let callback: ScreenResultCallback<KarhooCheckoutResult>
    private var carIconUrl: String = ""

    let quote: Quote
    @Published var bottomButtonText = UITexts.Booking.next.uppercased()
    @Published var quoteExpired: Bool = false
    var termsAndConditionsAccepted: Bool = false
    var showTrainNumberCell: Bool { shouldShowTrainNumberCell() }
    var showFlightNumberCell: Bool { shouldShowFlightNumberCell() }

    // MARK: - Properties

    private var cancellables: Set<AnyCancellable> = []

    private let quote: Quote
    private let journeyDetails: JourneyDetails
    private(set) var passengerDetails: PassengerDetails!
    private(set) var trip: TripInfo? // TODO: set value for trip ‼️
    private let journeyDetails: JourneyDetails
    private let bookingMetadata: [String: Any]?
    private var comments: String?
    private let callback: ScreenResultCallback<KarhooCheckoutResult>
    private var carIconUrl: String = ""

    let quote: Quote
    @Published var bottomButtonText = UITexts.Booking.next.uppercased()
    @Published var quoteExpired: Bool = false
    var termsAndConditionsAccepted: Bool = false
    var showTrainNumberCell: Bool { shouldShowTrainNumberCell() }
    var showFlightNumberCell: Bool { shouldShowFlightNumberCell() }

    // MARK: - Init & Config

    init(
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]?,
        quoteValidityWorker: QuoteValidityWorker = KarhooQuoteValidityWorker(),
        tripService: TripService = Karhoo.getTripService(),
        userService: UserService = Karhoo.getUserService(),
        passengerDetails: PassengerDetails? = PassengerInfo.shared.getDetails(),
        analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics(),
        baseFarePopupDialogBuilder: PopupDialogScreenBuilder = UISDKScreenRouting.default.popUpDialog(),
        sdkConfiguration: KarhooUISDKConfiguration =  KarhooUISDKConfigurationProvider.configuration,
        dateFormatter: DateFormatterType = KarhooDateFormatter(),
        vehicleRuleProvider: VehicleRulesProvider = KarhooVehicleRulesProvider(),
        router: NewCheckoutRouter,
        callback: @escaping ScreenResultCallback<KarhooCheckoutResult>
    ) {
        self.tripService = tripService
        self.userService = userService
        self.quoteValidityWorker = quoteValidityWorker
        self.passengerDetails = passengerDetails ?? PassengerInfo.shared.currentUserAsPassenger()
        self.sdkConfiguration = sdkConfiguration
        self.analytics = analytics
        self.quote = quote
        self.journeyDetails = journeyDetails
        self.bookingMetadata = bookingMetadata
        self.dateFormatter = dateFormatter
        self.vehicleRuleProvider = vehicleRuleProvider
        self.router = router
        self.callback = callback
        passangerDetailsViewModel = PassengerDetailsCellViewModel(onTap: { print("PassengerDetailsCell tapped") })
        trainNumberCellViewModel = TrainNumberCellViewModel(onTap: { print("TrainNumberCell tapped") })
        flightNumberCellViewModel = FlightNumberCellViewModel(onTap: { print("FlightNumberCell tapped") })
        commentCellViewModel = CommentCellViewModel(onTap: { print("CommentCell tapped") })
        termsConditionsViewModel = KarhooTermsConditionsViewModel(
            supplier: quote.fleet.name,
            termsStringURL: quote.fleet.termsConditionsUrl
        )
        legalNoticeViewModel = KarhooLegalNoticeViewModel()
        getImageUrl(for: quote, with: vehicleRuleProvider)
    }

    // MARK: - Endpoints

    func onAppear() {
        quoteValidityWorker.setQuoteValidityDeadline(quote) { [weak self] in
            self?.quoteExpired = true
        }

        paymentsWorker.statePublisher
            .sink { [weak self] bookingState in
                // TODO: handle booking state
                print(bookingState)
            }
            .store(in: &cancellables)
    }

    // MARK: Get simple data to display

    func getDateScheduledDescription() -> String {
        let date = journeyDetails.scheduledDate ?? Date()
        let dateFormatted = dateFormatter.display(
            date,
            dateStyle: .long,
            timeStyle: .none
        )
        let weekday = {
            guard let weekdayIndex = Calendar.current.dateComponents([.weekday], from: date).weekday else {
                return ""
            }
            return (Calendar.current.standaloneWeekdaySymbols[safe: weekdayIndex] ?? "") + ", "
        }()
        return "\(weekday)\(dateFormatted)".uppercased()
    }

    func getPrintedPickUpAddressLine1() -> String {
        journeyDetails.printedPickUpAddressLine1
    }

    func getPrintedPickUpAddressLine2() -> String {
        journeyDetails.printedPickUpAddressLine2
    }

    func getPrintedDropOffAddressLine1() -> String {
        journeyDetails.printedDropOffAddressLine1
    }

    func getPrintedDropOffAddressLine2() -> String {
        journeyDetails.printedDropOffAddressLine2
    }

    func getTimeLabelTextDescription() -> String {
        var scheduledTime: String {
            guard let date = journeyDetails.scheduledDate else {
                return ""
            }
            return dateFormatter.display(clockTime: date)
        }
        return journeyDetails.isScheduled ? scheduledTime : UITexts.Generic.now.uppercased()
    }
    
    func getVehicleDetailsCardViewModel() -> VehicleDetailsCardViewModel {
        var cancelationText: String? {
            guard let tripInfo = trip else {
                return nil
            }
            return KarhooFreeCancelationTextWorker.getFreeCancelationText(trip: tripInfo)
        }
        return VehicleDetailsCardViewModel(
            title: quote.vehicle.getVehicleTypeText(),
            passengerCapacity: quote.vehicle.passengerCapacity,
            luggageCapacity: quote.vehicle.luggageCapacity,
            fleetName: quote.fleet.name,
            carIconUrl: carIconUrl,
            fleetIconUrl: quote.fleet.logoUrl,
            cancelationText: cancelationText
        )
    }
    
    private func getImageUrl(for quote: Quote, with provider: VehicleRulesProvider) {
        provider.getRule(for: quote) { [weak self] rule in
            self?.carIconUrl = rule?.imagePath ?? self?.quote.fleet.logoUrl ?? ""
        }
    }

    // MARK: Interactions

    func didTapPassenger() {
        // TODO: - handle passenger flow
    }

    func didTapOptions() {
        // TODO: - handle options flow
    }

    func didTapFlightNumber() {
        // TODO: - handle flight number flow
    }

    func didSetTermsAndConditions(_ termsAndConditionsSelected: Bool) {
        // TODO: - handle t&c flow
    }

    func didSetComment(_ comment: String) {
        // TODO: - handle comment flow
    }

    func didTapConfirm() {
        // MARK: - Validate & proceed with payment flow
        guard validateIfAllRequiredDataAreProvided() else {
            return
        }
        submitBooking()
    }

    // MARK: - Booking

    private func submitBooking() {
        paymentsWorker.performBooking()
    }

    // MARK: - Analytics

    private func reportScreenOpened() {
        analytics.checkoutOpened(quote)
    }

    private func reportBookingEvent(quoteId: String) {
        analytics.bookingRequested(quoteId: quoteId)
    }

    private func reportBookingSuccess(tripId: String, quoteId: String?, correlationId: String?) {
        analytics.bookingSuccess(tripId: tripId, quoteId: quoteId, correlationId: correlationId)
    }

    private func reportBookingFailure(message: String, correlationId: String?) {
        analytics.bookingFailure(
            quoteId: quote.id,
            correlationId: correlationId ?? "",
            message: message,
            lastFourDigits: paymentsWorker.getPaymentNonce()?.lastFour ?? "",
            paymentMethodUsed: String(describing: KarhooUISDKConfigurationProvider.configuration.paymentManager),
            date: Date(),
            amount: quote.price.highPrice,
            currency: quote.price.currencyCode
        )
    }

    private func reportCardAuthorisationSuccess() {
        analytics.cardAuthorisationSuccess(quoteId: quote.id)
    }

    private func reportCardAuthorisationFailure(message: String) {
        analytics.cardAuthorisationFailure(
            quoteId: quote.id,
            errorMessage: message,
            lastFourDigits: userService.getCurrentUser()?.nonce?.lastFour ?? "",
            paymentMethodUsed: String(describing: KarhooUISDKConfigurationProvider.configuration.paymentManager),
            date: Date(),
            amount: quote.price.highPrice,
            currency: quote.price.currencyCode
        )
    }
    private func reportBookingConfirmationScreenOpened(tripId: String?, quoteId: String) {
        analytics.rideConfirmationScreenOpened(date: Date(), tripId: tripId, quoteId: quoteId)
    }

    // MARK: Interactions

    func didTapPassenger() {
        // TODO: - handle passenger flow
    }

    func didTapOptions() {
        // TODO: - handle options flow
    }

    func didTapFlightNumber() {
        // TODO: - handle flight number flow
    }

    func didSetTermsAndConditions(_ termsAndConditionsSelected: Bool) {
        // TODO: - handle t&c flow
    }

    func didSetComment(_ comment: String) {
        // TODO: - handle comment flow
    }

    func didTapConfirm() {
        // MARK: - Validate & proceed with payment flow
        guard validateIfAllRequiredDataAreProvided() else {
            return
        }
        submitBooking()
    }

    // MARK: - Booking

    private func submitBooking() {
        paymentsWorker.performBooking()
    }

    // MARK: - Analytics

    private func reportScreenOpened() {
        analytics.checkoutOpened(quote)
    }

    private func reportBookingEvent(quoteId: String) {
        analytics.bookingRequested(quoteId: quoteId)
    }

    private func reportBookingSuccess(tripId: String, quoteId: String?, correlationId: String?) {
        analytics.bookingSuccess(tripId: tripId, quoteId: quoteId, correlationId: correlationId)
    }

    private func reportBookingFailure(message: String, correlationId: String?) {
        analytics.bookingFailure(
            quoteId: quote.id,
            correlationId: correlationId ?? "",
            message: message,
            lastFourDigits: paymentsWorker.getPaymentNonce()?.lastFour ?? "",
            paymentMethodUsed: String(describing: KarhooUISDKConfigurationProvider.configuration.paymentManager),
            date: Date(),
            amount: quote.price.highPrice,
            currency: quote.price.currencyCode
        )
    }

    private func reportCardAuthorisationSuccess() {
        analytics.cardAuthorisationSuccess(quoteId: quote.id)
    }

    private func reportCardAuthorisationFailure(message: String) {
        analytics.cardAuthorisationFailure(
            quoteId: quote.id,
            errorMessage: message,
            lastFourDigits: userService.getCurrentUser()?.nonce?.lastFour ?? "",
            paymentMethodUsed: String(describing: KarhooUISDKConfigurationProvider.configuration.paymentManager),
            date: Date(),
            amount: quote.price.highPrice,
            currency: quote.price.currencyCode
        )
    }
    private func reportBookingConfirmationScreenOpened(tripId: String?, quoteId: String) {
        analytics.rideConfirmationScreenOpened(date: Date(), tripId: tripId, quoteId: quoteId)
    }

    // MARK: - Helpers

    private var isKarhooUser: Bool {
        switch Karhoo.configuration.authenticationMethod() {
        case .karhooUser: return true
        default: return false
        }
    }
    
    private func shouldShowTrainNumberCell() -> Bool {
        journeyDetails.isScheduled &&
        quote.fleet.capability.compactMap({ FleetCapabilities(rawValue: $0) }).contains(.trainTracking) &&
        journeyDetails.originLocationDetails?.details.type == .trainStation
    }
    
    private func shouldShowFlightNumberCell() -> Bool {
        journeyDetails.isScheduled &&
        quote.fleet.capability.compactMap({ FleetCapabilities(rawValue: $0) }).contains(.flightTracking) &&
        journeyDetails.originLocationDetails?.details.type == .airport
    }
        
    // MARK: - Price Details
    
    /// Called when the user taps on the price details section of the screen
    func showPriceDetails() {
        router.routeToPriceDetails(
            title: UITexts.Booking.priceDetailsTitle,
            quoteType: quote.quoteType
        )
    }

    // MARK: Validation

    private func validateIfAllRequiredDataAreProvided() -> Bool {
        guard let details = passengerDetails,
              details.areValid
        else {
            return false
        }
        guard paymentsWorker.isReadyToPerformPayment() else {
            return false
        }

        return true
	}
}
