//
//  BookingFlowCoordinator.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 04.04.2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

protocol MainFlowRouter {
    func startBooking(
        with journeyInfo: JourneyInfo?,
        passengerDetails: PassengerDetails?,
        filters: [QuoteListFilter]?,
        bookingMetadata: [String: Any]?,
        callback: ((BookingScreenResult) -> Void)?
    )
    
    // TODO: Add any parameters necessary to open these screens
    func routeToAllocationScreen()
    func routeToRidesList()
    func routeToTrackDriver()
}

protocol MainFlowBookingRouter {
    func routeToRidePlanning(
        ridePlanningCallback: @escaping (ScreenResult<KarhooRidePlanningResult>) -> Void
    )
    
    func routeToQuoteList(
        journeyDetails: JourneyDetails,
        onQuoteSelected: @escaping (_ quote: Quote, _ journeyDetails: JourneyDetails) -> Void
    )

    func routeToCheckout(
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]?,
        checkoutCallback: @escaping (ScreenResult<KarhooCheckoutResult>) -> Void
    )
    
    func resetDataAfterBooking()
}

/// The purpose of this class is to coordinate all flows inside the SDK including the full booking drop-in, driver tracking, ride list, etc.
final class MainFlowCoordinator: KarhooUISDKSceneCoordinator {
    
    // MARK: - Properties
    
    var baseViewController: BaseViewController
    var navigationController: UINavigationController?
    var childCoordinators: [KarhooUISDKSceneCoordinator] = []
    
    private var bookingCompletion: ((BookingScreenResult) -> Void)?
    
    static let shared = MainFlowCoordinator()
    let bookingStorage = KarhooBookingStorage.shared
    
    // MARK: - Initializator
    
    private init() {
        baseViewController = KarhooRidePlanningViewController()
    }
}

extension MainFlowCoordinator: MainFlowRouter {
    // MARK: - Booking drop-in flow
    func startBooking(
        with journeyInfo: JourneyInfo? = nil,
        passengerDetails: PassengerDetails? = nil,
        filters: [QuoteListFilter]? = nil,
        bookingMetadata: [String: Any]? = nil,
        callback: ((BookingScreenResult) -> Void)?
    ) {
        bookingCompletion = callback
        
        saveInjectedDataForCurrentBooking(
            journeyInfo: journeyInfo,
            passengerDetails: passengerDetails,
            filters: filters,
            bookingMetadata: bookingMetadata
        )
        routeToRidePlanning(ridePlanningCallback: handleRidePlanningCallback)
    }
    
    // MARK: Booking prep
    private func saveInjectedDataForCurrentBooking(
        journeyInfo: JourneyInfo? = nil,
        passengerDetails: PassengerDetails? = nil,
        filters: [QuoteListFilter]? = nil,
        bookingMetadata: [String: Any]? = nil
    ) {
        
        bookingStorage.passengerInfo.set(details: passengerDetails)
        bookingStorage.bookingMetadata = bookingMetadata
        
        var validatedJourneyInfo: JourneyInfo? {
            guard let origin = journeyInfo?.origin else {
                return nil
            }
            
            var isDateAllowed: Bool {
                guard let injectedDate = journeyInfo?.date else {
                    return false
                }
                return injectedDate >= Date().addingTimeInterval(60*60)
            }
            
            return JourneyInfo(
                origin: origin,
                destination: journeyInfo?.destination,
                date: isDateAllowed ? journeyInfo?.date : nil
            )
        }
        bookingStorage.journeyDetailsManager.setJourneyInfo(journeyInfo: validatedJourneyInfo)
    }
    
    // MARK: - Allocation
    func routeToAllocationScreen() {
        
    }
    
    // MARK: - Rides list & details
    
    func routeToRidesList() {
        
    }
    
    // MARK: - Track driver
    
    func routeToTrackDriver() {
        
    }
}

extension MainFlowCoordinator: MainFlowBookingRouter {
    // MARK: Ride Planning
    
    func routeToRidePlanning(
        ridePlanningCallback: @escaping (ScreenResult<KarhooRidePlanningResult>) -> Void
    ) {
        let ridePlanningCoordinator =
        KarhooRidePlanningCoordinator
            .Builder()
            .buildRidePlanningCoordinator(
                callback: ridePlanningCallback
            )
        
        baseViewController = ridePlanningCoordinator.baseViewController
        navigationController = ridePlanningCoordinator.navigationController
        addChild(ridePlanningCoordinator)
        
        ridePlanningCoordinator.start()
    }
    
    private func handleRidePlanningCallback(result: ScreenResult<KarhooRidePlanningResult>) {
        switch result {
        case .completed(let data):
            bookingStorage.journeyDetailsManager.silentReset(with: data.journeyDetails)
            routeToQuoteList(journeyDetails: data.journeyDetails, onQuoteSelected: onQuoteSelected)
            
        // TODO: treat other cases. Change bookingCompletion return type is necessary
        default:
            break
        }
    }
    
    // MARK: Quote list
    
    func routeToQuoteList(journeyDetails: JourneyDetails, onQuoteSelected: @escaping (Quote, JourneyDetails) -> Void) {
        guard let navigationController else {
            assertionFailure("Missing navigation controller required to open the quote list")
            return
        }
        
        // TODO: add filters to coordinator init
        let quoteListCoordinator = KarhooComponents.shared.quoteList(
            navigationController: navigationController,
            journeyDetails: journeyDetails,
            onQuoteSelected: onQuoteSelected
        )
        
        addChild(quoteListCoordinator)
        quoteListCoordinator.start()
    }
    
    func onQuoteSelected(quote: Quote, journeyDetails: JourneyDetails) {
        bookingStorage.journeyDetailsManager.silentReset(with: journeyDetails)
        bookingStorage.quote = quote
        
        routeToCheckout(
            quote: quote,
            journeyDetails: journeyDetails,
            bookingMetadata: bookingStorage.bookingMetadata,
            checkoutCallback: checkoutCallback
        )
    }
    
    // MARK: Checkout
    
    func routeToCheckout(
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]?,
        checkoutCallback: @escaping (ScreenResult<KarhooCheckoutResult>) -> Void
    ) {
        guard let navigationController else {
            assertionFailure("Missing navigation controller required to open the checkout")
            return
        }
        
        let checkoutCoordinator = KarhooComponents.shared.checkout(
            navigationController: navigationController,
            quote: quote,
            journeyDetails: journeyDetails,
            bookingMetadata: bookingMetadata,
            callback: checkoutCallback
        )
        
        addChild(checkoutCoordinator)
        checkoutCoordinator.start()
    }
    
    private func checkoutCallback(
        result: ScreenResult<KarhooCheckoutResult>
    ) {
        switch result {
        case .completed(let checkoutResult):
            // TODO: properly handle this scenario
            
            print("Checkout completed with trip id \(checkoutResult.tripInfo.tripId)")
            if checkoutResult.tripInfo.dateScheduled != nil {
                bookingCompletion?(BookingScreenResult.prebookConfirmed(tripInfo: checkoutResult.tripInfo))
            } else {
                bookingCompletion?(BookingScreenResult.tripAllocated(tripInfo: checkoutResult.tripInfo))
            }
            self.resetDataAfterBooking()
            navigationController?.popToRootViewController(animated: true)
            
            // TODO: treat other cases. Change bookingCompletion return type is necessary
            default:
                break
        }
    }
    
    // MARK: Post booking cleanup
    func resetDataAfterBooking() {
        bookingStorage.reset()
    }
}
