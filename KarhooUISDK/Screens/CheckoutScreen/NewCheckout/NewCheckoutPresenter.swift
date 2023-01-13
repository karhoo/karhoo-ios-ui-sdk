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

enum NewCheckoutState {
    case loading
    case asap
    case scheduled
}

final class KarhooNewCheckoutViewModel: ObservableObject {

    // MARK: - Properties

    let quote: Quote
    private(set) var passengerDetails: PassengerDetails!
    private(set) var trip: TripInfo?

    private let callback: ScreenResultCallback<KarhooCheckoutResult>
    private let journeyDetails: JourneyDetails
    private let quoteValidityWorker: QuoteValidityWorker
    private let threeDSecureProvider: ThreeDSecureProvider?
    private let tripService: TripService
    private let userService: UserService
    private let bookingMetadata: [String: Any]?
    private let paymentNonceProvider: PaymentNonceProvider
    private let sdkConfiguration: KarhooUISDKConfiguration
    private let analytics: Analytics
    private let appStateNotifier: AppStateNotifierProtocol
    private var comments: String?
    private var bookingRequestInProgress: Bool = false
    private var flightDetailsScreenIsPresented: Bool = false
    private let baseFareDialogBuilder: PopupDialogScreenBuilder
    private var cardRegistrationFlow: CardRegistrationFlow
    private let dateFormatter: DateFormatterType
    private let vehicleRuleProvider: VehicleRulesProvider
    private var carIconUrl: String = ""
    
    var passangerDetailsViewModel: PassengerDetailsCellViewModel
    var trainNumberCellViewModel: TrainNumberCellViewModel
    var flightNumberCellViewModel: FlightNumberCellViewModel
    var commentCellViewModel: CommentCellViewModel
    
    var showTrainNumberCell: Bool = false
    var showFlightNumberCell: Bool = false
    
    // MARK: - Init & Config

    init(
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]?,
        quoteValidityWorker: QuoteValidityWorker = KarhooQuoteValidityWorker(),
        threeDSecureProvider: ThreeDSecureProvider? = nil,
        tripService: TripService = Karhoo.getTripService(),
        userService: UserService = Karhoo.getUserService(),
        passengerDetails: PassengerDetails? = PassengerInfo.shared.getDetails(),
        analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics(),
        appStateNotifier: AppStateNotifierProtocol = AppStateNotifier(),
        baseFarePopupDialogBuilder: PopupDialogScreenBuilder = UISDKScreenRouting.default.popUpDialog(),
        paymentNonceProvider: PaymentNonceProvider = PaymentFactory().nonceProvider(),
        sdkConfiguration: KarhooUISDKConfiguration =  KarhooUISDKConfigurationProvider.configuration,
        cardRegistrationFlow: CardRegistrationFlow = PaymentFactory().getCardFlow(),
        dateFormatter: DateFormatterType = KarhooDateFormatter(),
        vehicleRuleProvider: VehicleRulesProvider = KarhooVehicleRulesProvider(),
        callback: @escaping ScreenResultCallback<KarhooCheckoutResult>
    ) {
        self.threeDSecureProvider = threeDSecureProvider ?? sdkConfiguration.paymentManager.threeDSecureProvider
        self.tripService = tripService
        self.callback = callback
        self.userService = userService
        self.quoteValidityWorker = quoteValidityWorker
        self.passengerDetails = passengerDetails ?? PassengerInfo.shared.currentUserAsPassenger()
        self.paymentNonceProvider = paymentNonceProvider
        self.sdkConfiguration = sdkConfiguration
        self.appStateNotifier = appStateNotifier
        self.analytics = analytics
        self.baseFareDialogBuilder = baseFarePopupDialogBuilder
        self.quote = quote
        self.journeyDetails = journeyDetails
        self.bookingMetadata = bookingMetadata
        self.cardRegistrationFlow = cardRegistrationFlow
        self.dateFormatter = dateFormatter
        self.vehicleRuleProvider = vehicleRuleProvider
        passangerDetailsViewModel = PassengerDetailsCellViewModel(onTap: { print("PassengerDetailsCell tapped") })
        trainNumberCellViewModel = TrainNumberCellViewModel(onTap: { print("TrainNumberCell tapped") })
        flightNumberCellViewModel = FlightNumberCellViewModel(onTap: { print("FlightNumberCell tapped") })
        commentCellViewModel = CommentCellViewModel(onTap: { print("CommentCell tapped") })
        showTrainNumberCell = shouldShowTrainNumberCell()
        showFlightNumberCell = shouldShowFlightNumberCell()
        getImageUrl(for: quote, with: vehicleRuleProvider)
    }

    func viewDidLoad() {
       quoteValidityWorker.setQuoteValidityDeadline(quote) {
           // TODO: handle validity expiration
       }
    }

    // MARK: - Endpoints

    func getDateScheduledDescription() -> String {
        let date = trip?.dateScheduled ?? Date()
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
        VehicleDetailsCardViewModel(
            title: quote.vehicle.getVehicleTypeText(),
            passengerCapacity: quote.vehicle.passengerCapacity,
            luggageCapacity: quote.vehicle.luggageCapacity,
            fleetName: quote.fleet.name,
            carIconUrl: carIconUrl,
            fleetIconUrl: quote.fleet.logoUrl
        )
    }
    
    private func getImageUrl(for quote: Quote, with provider: VehicleRulesProvider) {
        provider.getRule(for: quote) { [weak self] rule in
            self?.carIconUrl = rule?.imagePath ?? self?.quote.fleet.logoUrl ?? ""
        }
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
}
