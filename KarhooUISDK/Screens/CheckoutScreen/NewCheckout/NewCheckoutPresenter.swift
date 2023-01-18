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

    private let passengerDetailsWorker: KarhooNewCheckoutPassengerDetailsWorker

    // MARK: - Nested views models

    var passangerDetailsViewModel: PassengerDetailsCellViewModel
    var trainNumberCellViewModel: TrainNumberCellViewModel
    var flightNumberCellViewModel: FlightNumberCellViewModel
    var commentCellViewModel: CommentCellViewModel
    var termsConditionsViewModel: KarhooTermsConditionsViewModel
    var legalNoticeViewModel: KarhooLegalNoticeViewModel!

    private let router: NewCheckoutRouter

    // MARK: - Properties

    private var cancellables: Set<AnyCancellable> = []

    var passengerDetailsPublisher: Published<PassengerDetails?>.Publisher {
        passengerDetailsWorker.$passengerDetails
    }
    private(set) var trip: TripInfo?
    private let journeyDetails: JourneyDetails
    private let bookingMetadata: [String: Any]?
    private var comments: String?
    private var carIconUrl: String = ""

    let quote: Quote
    @Published var confirmButtonTitle = UITexts.Booking.next.uppercased()
    @Published var quoteExpired: Bool = false
    @Published var state: NewCheckoutState = .loading
    @Published var showLoadingOverview = true
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
        router: NewCheckoutRouter
    ) {
        self.tripService = tripService
        self.userService = userService
        self.quoteValidityWorker = quoteValidityWorker
        self.passengerDetailsWorker = KarhooNewCheckoutPassengerDetailsWorker(details: passengerDetails)
        self.sdkConfiguration = sdkConfiguration
        self.analytics = analytics
        self.quote = quote
        self.journeyDetails = journeyDetails
        self.bookingMetadata = bookingMetadata
        self.dateFormatter = dateFormatter
        self.vehicleRuleProvider = vehicleRuleProvider
        self.router = router
        self.legalNoticeViewModel = KarhooLegalNoticeViewModel()
        self.passangerDetailsViewModel = PassengerDetailsCellViewModel()
        self.trainNumberCellViewModel = TrainNumberCellViewModel()
        self.flightNumberCellViewModel = FlightNumberCellViewModel()
        self.commentCellViewModel = CommentCellViewModel()
        self.termsConditionsViewModel = KarhooTermsConditionsViewModel(
            supplier: quote.fleet.name,
            termsStringURL: quote.fleet.termsConditionsUrl
        )

        self.getImageUrl(for: quote, with: vehicleRuleProvider)
        self.setupBinding()
        self.setupInitialState()
    }

    // MARK: - Endpoints

    func onAppear() {
        quoteValidityWorker.setQuoteValidityDeadline(quote) { [weak self] in
            self?.quoteExpired = true
        }
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
            return (Calendar.current.standaloneWeekdaySymbols[safe: max(weekdayIndex - 1, 0)] ?? "") + ", "
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

    func didSetComment(_ comment: String) {
        // TODO: - handle comment flow
    }

    func didTapConfirm() {
        // MARK: - Validate & proceed with payment flow
        guard validateIfAllRequiredDataAreProvided() else {
            withAnimation {
                state = .gatheringInfo
            }
            return
        }
        submitBooking()
    }

    // MARK: - State/main flow methods

    private func setupBinding() {
        paymentsWorker.$bookingState
            .sink { [weak self] bookingState in
                self?.handleBookingState(bookingState)
            }
            .store(in: &cancellables)

        $state
            .sink { [weak self] checkoutState in
                self?.handleStateUpdate(checkoutState)
            }
            .store(in: &cancellables)

        // Nested VMs binding

        passengerDetailsPublisher
            .sink { [weak self] passengerDetails in
                self?.passangerDetailsViewModel.update(using: passengerDetails)
                self?.checkIfNeedsToUpdateState()
            }
            .store(in: &cancellables)

        if termsConditionsViewModel.showAgreementRequired {
            termsConditionsViewModel.$confirmed
                .sink { [weak self] _ in
                    self?.checkIfNeedsToUpdateState()
                }
                .store(in: &cancellables)
        }

        passangerDetailsViewModel.onTap = { [weak self] in
            self?.showPassengerDetails()
        }
        
        flightNumberCellViewModel.onTap = { [weak self] in
            self?.showFlightNumberBottomSheet()
        }
        
        trainNumberCellViewModel.onTap = { [weak self] in
            self?.showTrainNumberBottomSheet()
        }
    }

    private func setupInitialState() {
        state = .gatheringInfo
    }

    private func handleStateUpdate(_ state: NewCheckoutState) {
        switch state {
        case .loading:
            // In this stage the view is showing loading overlay
            confirmButtonTitle = UITexts.Booking.next.uppercased()
        case .gatheringInfo:
            confirmButtonTitle = UITexts.Booking.next.uppercased()
        case .readyToBook:
            confirmButtonTitle = UITexts.Booking.pay.uppercased()
        }
    }

    private func submitBooking() {
        withAnimation {
            state = .loading
        }
        paymentsWorker.performBooking()
    }

    private func handleBookingState(_ bookingState: BookingState) {
        switch bookingState {
        case .idle:
            break
        case .loading:
            break
        case .failure(let error):
            print(error)
        case .success(let tripInfo):
            // TODO: get & pass a proper Loyalty model
            router.routeSuccessScene(
                with: tripInfo,
                journeyDetails: journeyDetails,
                quote: quote,
                loyaltyInfo: .init(shouldShowLoyalty: false, loyaltyPoints: 0, loyaltyMode: .none)
            )
        }
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
    
    // MARK: - Update nested views state

    // MARK: - Routing

    private func showPassengerDetails() {
        router.routeToPassengerDetails(
            passengerDetailsWorker.passengerDetails,
            delegate: passengerDetailsWorker
        )
    }

    /// Called when the user taps on the price details section of the screen
    func showPriceDetails() {
        router.routeToPriceDetails(
            title: UITexts.Booking.priceDetailsTitle,
            quoteType: quote.quoteType
        )
    }
    
    /// Called when the user taps on the flight number cell
    func showFlightNumberBottomSheet() {
        router.routeToFlightNumber(
            title: UITexts.Booking.flightTitle,
            flightNumber: flightNumberCellViewModel.getFlightNumber()
        )
    }
    
    /// Called when the user taps on the train number cell
    func showTrainNumberBottomSheet() {
        router.routeToTrainNumber(
            title: UITexts.Booking.trainTitle,
            trainNumber: trainNumberCellViewModel.getTrainNumber()
        )
    }

    // MARK: Validation

    private func checkIfNeedsToUpdateState() {
        guard validateIfAllRequiredDataAreProvided(triggerAdditionalBehavior: false) else {
            return
        }
        withAnimation {
            state = .readyToBook
        }
    }

    /// Validate if all required data are in place. If some data is missing, the method will trigger proper behavior, like opening the passenger details screen.
    private func validateIfAllRequiredDataAreProvided(triggerAdditionalBehavior: Bool = true) -> Bool {
        guard passengerDetailsWorker.passengerDetails?.areValid ?? false
        else {
            if triggerAdditionalBehavior {
                showPassengerDetails()
            }
            return false
        }

        guard !termsConditionsViewModel.isAcceptanceRequired || termsConditionsViewModel.confirmed
        else {
            if triggerAdditionalBehavior {
                termsConditionsViewModel.showAgreementRequired = true
            }
            return false
        }

        // TODO: Add Loyalty validation here

        guard paymentsWorker.isReadyToPerformPayment() else {
            return false
        }

        return true
	}
}
