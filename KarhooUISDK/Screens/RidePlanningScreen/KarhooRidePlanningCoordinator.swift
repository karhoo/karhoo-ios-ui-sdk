//
//  KarhooRidePlanningCoordinator.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 04.04.2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

final class KarhooRidePlanningCoordinator: RidePlanningCoordinator {
    // TODO: actually use these, they've been just copy-pasted here as a reminder
//    private let locationService: LocationService
//
//    public init(locationService: LocationService = KarhooLocationService()) {
//        self.locationService = locationService
//    }
    
    // MARK: - Nested types
    
    class Builder: RidePlanningScreenBuilder {
        public func buildRidePlanningCoordinator(
            callback: ScreenResultCallback<KarhooRidePlanningResult>?
        ) -> KarhooUISDKSceneCoordinator {

            let coordinator = KarhooRidePlanningCoordinator(
                navigationController: nil,
                callback: callback!
            )
            
            guard
                let navigationController = coordinator.navigationController,
                let viewController = coordinator.baseViewController as? RidePlanningViewController
            else {
                assertionFailure("Missing navigation in Ride Planning coordinator")
                return coordinator
            }
            
            if let sideMenuRouting = KarhooUI.sideMenuHandler {
                let sideMenu = UISDKScreenRouting
                    .default.sideMenu().buildSideMenu(
                        hostViewController: viewController,
                        routing: sideMenuRouting
                    )
                viewController.set(sideMenu: sideMenu)
                viewController.set(leftNavigationButton: .menuIcon)
            } else {
                viewController.set(leftNavigationButton: .exitIcon)
            }
            
            navigationController.modalPresentationStyle = .fullScreen
            return coordinator
        }
    }
    // MARK: - Properties

    var childCoordinators: [KarhooUISDKSceneCoordinator] = []
    var baseViewController: BaseViewController { viewController }
    private(set) var navigationController: UINavigationController?
    private(set) var viewController: RidePlanningViewController!
    private(set) var viewModel: KarhooRidePlanningViewModel?

    private var callback: ((ScreenResult<KarhooRidePlanningResult>) -> Void)?
    
    private var journeyDetailsManager: JourneyDetailsManager

    // MARK: - Initializator

    init(
        navigationController: UINavigationController?,
        journeyDetails: JourneyDetails? = nil,
        filters: [QuoteListFilter]? = nil,
        journeyDetailsManager: JourneyDetailsManager = KarhooJourneyDetailsManager(),
        callback: ((ScreenResult<KarhooRidePlanningResult>) -> Void)?
    ) {
        self.journeyDetailsManager = journeyDetailsManager
        if let journeyDetails {
            journeyDetailsManager.silentReset(with: journeyDetails)
        }
        
        if let filters {
            SharedQuoteFilters.shared.set(filters: filters)
        }
        
        self.viewModel = KarhooRidePlanningViewModel(
            router: self
        )
        self.viewController = KarhooRidePlanningViewController().then {
            $0.setupBinding(viewModel!)
        }
        self.navigationController = navigationController ?? NavigationController(
            rootViewController: self.viewController,
            style: .primary
        )
        self.callback = callback
    }
}

extension KarhooRidePlanningCoordinator: RidePlanningRouter {

    func routeToQuoteList(
        details: JourneyDetails,
        onQuoteSelected: @escaping (Quote, JourneyDetails) -> Void
    ) {
        
    }
    
    func routeToCheckout(
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]?,
        bookingRequestCompletion: @escaping (ScreenResult<KarhooCheckoutResult>, KarhooSDK.Quote, JourneyDetails) -> Void
    ) {
        
    }
    
    func exitPressed() {
        viewController?.dismiss(animated: true, completion: { [weak self] in
            self?.callback?(ScreenResult.cancelled(byUser: true))
        })
    }
    
    func routeToAllocationScreen() {}
    
    func routeToDatePicker() {}
}
