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
            journeyDetails: JourneyDetails? = KarhooJourneyDetailsManager.shared.getJourneyDetails(),
            filters: [QuoteListFilter]? = KarhooQuoteFilters.shared.getFilters(),
            callback: ScreenResultCallback<KarhooRidePlanningResult>?
        ) -> KarhooUISDKSceneCoordinator {

            if let journeyDetails {
                KarhooJourneyDetailsManager.shared.silentReset(with: journeyDetails)
            }
            
            KarhooQuoteFilters.shared.set(filters: filters)
            
            let coordinator = KarhooRidePlanningCoordinator(
                navigationController: nil,
                callback: callback!
            )
            
            guard
                let navigationController = coordinator.navigationController
            else {
                assertionFailure("Missing navigation in Ride Planning coordinator")
                return coordinator
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
    private var filtersManager: QuoteFilters

    // MARK: - Initializator
    /// Pass journey details and filters if using Ride Planning as an independent component
    /// If values are passed, they will override the existing stored information for the current booking
    init(
        navigationController: UINavigationController?,
        journeyDetails: JourneyDetails? = nil,
        filters: [QuoteListFilter]? = nil,
        journeyDetailsManager: JourneyDetailsManager = KarhooJourneyDetailsManager.shared,
        filtersManager: QuoteFilters = KarhooQuoteFilters.shared,
        callback: ((ScreenResult<KarhooRidePlanningResult>) -> Void)?
    ) {
        self.journeyDetailsManager = journeyDetailsManager
        if let journeyDetails {
            journeyDetailsManager.silentReset(with: journeyDetails)
        }
        
        self.filtersManager = filtersManager
        if let filters {
            KarhooQuoteFilters.shared.set(filters: filters)
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
    func exitPressed() {
        viewController?.dismiss(animated: true, completion: { [weak self] in
            self?.callback?(ScreenResult.cancelled(byUser: true))
        })
    }
    
    func finished() {
        guard let journeyDetails = journeyDetailsManager.getJourneyDetails() else {
            assertionFailure("Journey details should not be nil at the end of the ride planning flow")
            return
        }
        
        let result = KarhooRidePlanningResult(
            journeyDetails: journeyDetails,
            filters: filtersManager.getFilters()
        )
        
        callback?(ScreenResult.completed(result: result))
    }
}
