//
//  CheckoutViewModel.swift
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

enum CheckoutState: Equatable {
    /// Screen is locked and user's interactions are disabled. Used for crucial data loading (like payment confirmation)
    case loading
    /// UI is enabled but some data's missing in order to proceed with booking, so user needs to provide them.
    case gatheringInfo
    /// UI is enabled and all data's in place. Scene is waiting for user's confirmation.
    case readyToBook

    case error(title: String, message: String?)
}

final class KarhooCheckoutViewModel: ObservableObject {

    // MARK: - Dependencies

    private let quoteValidityWorker: QuoteValidityWorker
    private let tripService: TripService
    private let userService: UserService
    private let analytics: Analytics
    private let sdkConfiguration: KarhooUISDKConfiguration
    private let bookingWorker: CheckoutBookingWorker
    private let loyaltyWorker: LoyaltyWorker
    private let dateFormatter: DateFormatterType
    private let vehicleRuleProvider: VehicleRulesProvider

    private let passengerDetailsWorker: CheckoutPassengerDetailsWorker

    // MARK: - Nested views models

    var passangerDetailsViewModel: PassengerDetailsCellViewModel
    var trainNumberCellViewModel: TrainNumberCellViewModel
    var flightNumberCellViewModel: FlightNumberCellViewModel
    var commentCellViewModel: CommentCellViewModel
    var termsConditionsViewModel: KarhooTermsConditionsViewModel
    var legalNoticeViewModel: KarhooLegalNoticeViewModel!
    var loyaltyViewModel: LoyaltyViewModel

    private let router: CheckoutRouter

    // MARK: - Properties

    private var cancellables: Set<AnyCancellable> = []

    private let journeyDetails: JourneyDetails
    private var carIconUrl: String = ""

    let quote: Quote
    @Published var confirmButtonTitle = UITexts.Booking.next.uppercased()
    @Published var quoteExpired: Bool = false
    @Published var state: CheckoutState = .loading
    @Published var showError = false
    @Published var errorToPresent: (title: String?, message: String?)?
    @Published var scrollToTermsConditions = false
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
        sdkConfiguration: KarhooUISDKConfiguration = KarhooUISDKConfigurationProvider.configuration,
        dateFormatter: DateFormatterType = KarhooDateFormatter(),
        vehicleRuleProvider: VehicleRulesProvider = KarhooVehicleRulesProvider(),
        bookingWorkerClosure: (Quote, JourneyDetails, [String: Any]?) -> CheckoutBookingWorker = { quote, journeyDetails, bookingMetadata in
            KarhooCheckoutBookingWorker(quote: quote, journeyDetails: journeyDetails, bookingMetadata: bookingMetadata)
        },
        passengerDetailsWorkerClosure: (PassengerDetails?) -> CheckoutPassengerDetailsWorker = { KarhooCheckoutPassengerDetailsWorker(details: $0) },
        loyaltyWorker: LoyaltyWorker = KarhooLoyaltyWorker.shared,
        router: CheckoutRouter
    ) {
        self.tripService = tripService
        self.userService = userService
        self.quoteValidityWorker = quoteValidityWorker
        self.bookingWorker = bookingWorkerClosure(quote, journeyDetails, bookingMetadata)
        self.passengerDetailsWorker = passengerDetailsWorkerClosure(passengerDetails ?? PassengerInfo.shared.currentUserAsPassenger())
        self.sdkConfiguration = sdkConfiguration
        self.analytics = analytics
        self.quote = quote
        self.journeyDetails = journeyDetails
        self.dateFormatter = dateFormatter
        self.vehicleRuleProvider = vehicleRuleProvider
        self.router = router
        self.legalNoticeViewModel = KarhooLegalNoticeViewModel()
        self.passangerDetailsViewModel = PassengerDetailsCellViewModel(passengerDetails: passengerDetails)
        self.trainNumberCellViewModel = TrainNumberCellViewModel()
        self.flightNumberCellViewModel = FlightNumberCellViewModel()
        self.commentCellViewModel = CommentCellViewModel()
        self.termsConditionsViewModel = KarhooTermsConditionsViewModel(
            supplier: quote.fleet.name,
            termsStringURL: quote.fleet.termsConditionsUrl
        )
        self.loyaltyWorker = loyaltyWorker
        loyaltyWorker.setup(using: quote)
        self.loyaltyViewModel = LoyaltyViewModel(worker: loyaltyWorker)
        self.getImageUrl(for: quote, with: vehicleRuleProvider)
        self.setupBinding()
        self.checkIfNeedsToUpdateState()
    }

    // MARK: - Endpoints

    func onAppear() {
        reportScreenOpened()
        quoteValidityWorker.setQuoteValidityDeadline(quote) { [weak self] in
            self?.showError = true
            self?.quoteExpired = true
        }
    }

    func didTapConfirm() {
        // MARK: - Validate & proceed with payment flow
        guard validateIfAllRequiredDataAreProvided(triggerAdditionalBehavior: true) else {
            withAnimation {
                state = .gatheringInfo
            }
            return
        }
        submitBooking()
    }

    // MARK: Get simple data to display

    func getDateScheduledDescription() -> String {
        let date = journeyDetails.scheduledDate ?? Date()
        
        if let timezone = journeyDetails.originLocationDetails?.timezone() {
            dateFormatter.set(timeZone: timezone)
        }
        
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
        
        let nowTime = QtaStringFormatter()
            .qtaString(
                min: quote.vehicle.qta.lowMinutes,
                max: quote.vehicle.qta.highMinutes
            )
        
        return journeyDetails.isScheduled ? scheduledTime : nowTime
    }
    
    func getVehicleDetailsCardViewModel() -> VehicleDetailsCardViewModel {
        var cancelationText: String? {
            KarhooFreeCancelationTextWorker.getFreeCancelationText(quote: quote, journeyDetails: journeyDetails)
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

    // MARK: - State/main flow methods

    private func setupBinding() {
        bookingWorker.stateSubject
            .dropFirst()
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

        passengerDetailsWorker.passengerDetailsSubject
            .sink { [weak self] passengerDetails in
                self?.passangerDetailsViewModel.update(using: passengerDetails)
                self?.bookingWorker.update(passengerDetails: passengerDetails)
                self?.checkIfNeedsToUpdateState()
            }
            .store(in: &cancellables)

        if termsConditionsViewModel.isAcceptanceRequired {
            termsConditionsViewModel.confirmed
                .dropFirst()
                .sink { [weak self] _ in
                    self?.scrollToTermsConditions = false
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

        flightNumberCellViewModel.flightNumberSubject
            .dropFirst()
            .sink { [weak self] trainNumber in
                self?.bookingWorker.update(flightNumber: trainNumber)
            }
            .store(in: &cancellables)

        trainNumberCellViewModel.onTap = { [weak self] in
            self?.showTrainNumberBottomSheet()
        }

        trainNumberCellViewModel.trainNumberSubject
            .dropFirst()
            .sink { [weak self] trainNumber in
                self?.bookingWorker.update(trainNumber: trainNumber)
            }
            .store(in: &cancellables)
        
        commentCellViewModel.onTap = { [weak self] in
            self?.showCommentBottomSheet()
        }

        commentCellViewModel.commentSubject
            .dropFirst()
            .sink { [weak self] comment in
                self?.bookingWorker.update(comment: comment)
            }
            .store(in: &cancellables)
    }

    private func setupInitialState() {
        state = .gatheringInfo
    }

    private func handleStateUpdate(_ state: CheckoutState) {
        showError = false
        switch state {
        case .loading:
            // In this stage the view is showing loading overlay
            break
        case .gatheringInfo:
            confirmButtonTitle = UITexts.Booking.next.uppercased()
        case .readyToBook:
            confirmButtonTitle = UITexts.Booking.pay.uppercased()
        case .error(title: let title, message: let message):
            showError = true
            errorToPresent = (title: title, message: message)
        }
    }

    private func submitBooking() {
        withAnimation {
            state = .loading
        }
        bookingWorker.performBooking()
    }

    private func handleBookingState(_ bookingState: CheckoutBookingState) {
        switch bookingState {
        case .idle:
            withAnimation {
                state = validateIfAllRequiredDataAreProvided() ? .readyToBook : .gatheringInfo
            }
        case .loading:
            break
        case .failure(let error):
            state = .error(title: UITexts.Generic.error, message: error.localizedMessage)
        case .success(let tripInfo):
            quoteValidityWorker.invalidate()
            router.routeSuccessScene(
                with: tripInfo,
                journeyDetails: journeyDetails,
                quote: quote,
                loyaltyInfo: loyaltyWorker.getBasicLoyaltyInfo()
            )
        }
    }

    // MARK: - Analytics

    private func reportScreenOpened() {
        analytics.checkoutOpened(quote)
    }

    // MARK: - Helpers

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
            passengerDetailsWorker.passengerDetailsSubject.value,
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
    private func showFlightNumberBottomSheet() {
        router.routeToFlightNumber(
            title: UITexts.Booking.flightTitle,
            flightNumber: flightNumberCellViewModel.getFlightNumber()
        )
    }
    
    /// Called when the user taps on the train number cell
    private func showTrainNumberBottomSheet() {
        router.routeToTrainNumber(
            title: UITexts.Booking.trainTitle,
            trainNumber: trainNumberCellViewModel.getTrainNumber()
        )
    }
    
    /// Called when the user taps on the comment cell
    private func showCommentBottomSheet() {
        router.routeToComment(
            title: UITexts.Booking.commentsTitle,
            comments: commentCellViewModel.getComment()
        )
    }

    // MARK: Validation

    private func checkIfNeedsToUpdateState() {
        withAnimation {
            state = validateIfAllRequiredDataAreProvided() ? .readyToBook : .gatheringInfo
        }
    }

    /// Validate if all required data are in place. If some data is missing, the method will trigger proper behavior, like opening the passenger details screen.
    private func validateIfAllRequiredDataAreProvided(triggerAdditionalBehavior: Bool = false) -> Bool {
        guard passengerDetailsWorker.passengerDetailsSubject.value?.areValid ?? false
        else {
            if triggerAdditionalBehavior {
                showPassengerDetails()
            }
            return false
        }

        guard !(termsConditionsViewModel.isAcceptanceRequired) || termsConditionsViewModel.confirmed.value
        else {
            if triggerAdditionalBehavior {
                termsConditionsViewModel.showAgreementRequired = true
                scrollToTermsConditions = true
            }
            return false
        }

        return true
	}
}
