//
//  BookingFlowCoordinator.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 04.04.2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

final class BookingFlowCoordinator: KarhooUISDKSceneCoordinator {
    var baseViewController: BaseViewController
    var navigationController: UINavigationController?
    var childCoordinators: [KarhooUISDKSceneCoordinator] = []
    
    private var bookingCompletion: ((BookingScreenResult) -> Void)?
    
    static let shared = BookingFlowCoordinator()
    
    private init() {
        baseViewController = KarhooRidePlanningViewController()
    }
    
    func start(
        with journeyInfo: JourneyInfo? = nil,
        passengerDetails: PassengerDetails? = nil,
        filters: [QuoteListFilter]? = nil,
        bookingMetadata: [String: Any]? = nil,
        callback: ((BookingScreenResult) -> Void)?
    ) {
        bookingCompletion = callback
        
        saveInjectedData(
            journeyInfo: journeyInfo,
            passengerDetails: passengerDetails,
            filters: filters,
            bookingMetadata: bookingMetadata
        )
        routeToRidePlanning()
    }
    
    private func saveInjectedData(
        journeyInfo: JourneyInfo? = nil,
        passengerDetails: PassengerDetails? = nil,
        filters: [QuoteListFilter]? = nil,
        bookingMetadata: [String: Any]? = nil
    ) {
        PassengerInfo.shared.set(details: passengerDetails)
        BookingMetadata.shared.set(metadata: bookingMetadata)
        
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
        KarhooJourneyDetailsManager.shared.setJourneyInfo(journeyInfo: validatedJourneyInfo)
    }
    
    private func routeToRidePlanning() {
        let ridePlanningCoordinator =
        KarhooRidePlanningCoordinator
            .Builder()
            .buildRidePlanningCoordinator { [weak self] result in
                self?.handleRidePlanningCallback(result: result)
            }
        
        baseViewController = ridePlanningCoordinator.baseViewController
        navigationController = ridePlanningCoordinator.navigationController
        addChild(ridePlanningCoordinator)
        
        ridePlanningCoordinator.start()
    }
    
    private func handleRidePlanningCallback(result: ScreenResult<KarhooRidePlanningResult>) {
        switch result {
        case .completed(let data):
            routeToQuoteList(with: data)
            
        // TODO: treat other cases. Change bookingCompletion return type is necessary
        default:
            break
        }
    }
    
    private func routeToQuoteList(with data: KarhooRidePlanningResult) {
        guard let navigationController else {
            assertionFailure("Missing navigation controller required to open the quote list")
            return
        }
        
        // TODO: add filters to coordinator init
        let quoteListCoordinator = KarhooComponents.shared.quoteList(
            navigationController: navigationController,
            journeyDetails: data.journeyDetails) { [weak self] quote, journeyDetails in
                self?.routeToCheckout(with: quote, journeyDetails: journeyDetails)
            }
        
        addChild(quoteListCoordinator)
        quoteListCoordinator.start()
    }
    
    private func routeToCheckout(with quote: Quote, journeyDetails: JourneyDetails) {
        guard let navigationController else {
            assertionFailure("Missing navigation controller required to open the checkout")
            return
        }
        
        let checkoutCoordinator = KarhooComponents.shared.checkout(
            navigationController: navigationController,
            quote: quote,
            journeyDetails: journeyDetails,
            bookingMetadata: BookingMetadata.shared.getMetadata()) { [weak self] result in
                self?.handleCheckoutResult(result)
            }
        
        addChild(checkoutCoordinator)
        checkoutCoordinator.start()
    }
    
    private func handleCheckoutResult(_ result: ScreenResult<KarhooCheckoutResult>) {
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
    
    private func resetDataAfterBooking() {
        KarhooJourneyDetailsManager.shared.reset()
        BookingMetadata.shared.reset()
        SharedQuoteFilters.shared.reset()
    }
}
