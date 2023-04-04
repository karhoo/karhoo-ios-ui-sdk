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
    
    // MARK: - Properties

    var childCoordinators: [KarhooUISDKSceneCoordinator] = []
    var baseViewController: BaseViewController { viewController }
    private(set) var navigationController: UINavigationController?
    private(set) var viewController: RidePlanningViewController!
    private(set) var viewModel: KarhooRidePlanningViewModel?

    private var callback: ((ScreenResult<KarhooRidePlanningResult>) -> Void)?

    // MARK: - Initializator

    init(
        navigationController: UINavigationController?,
        bookingMetadata: [String: Any]?,
        callback: ((ScreenResult<KarhooRidePlanningResult>) -> Void)?
    ) {
        self.viewModel = KarhooRidePlanningViewModel(
            bookingMetadata: bookingMetadata,
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
