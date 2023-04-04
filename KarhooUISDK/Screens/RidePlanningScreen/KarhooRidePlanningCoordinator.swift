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
    // MARK: - Nested types

    class Builder: RidePlanningScreenBuilder {
        func buildRidePlanningCoordinator(
            navigationController: UINavigationController?,
            journeyInfo: JourneyInfo? = nil,
            passengerDetails: PassengerDetails? = nil,
            bookingMetadata: [String: Any]? = nil,
            callback: @escaping ScreenResultCallback<KarhooRidePlanningResult>
        ) -> KarhooUISDKSceneCoordinator {
            KarhooRidePlanningCoordinator(
                navigationController: navigationController,
                journeyInfo: journeyInfo,
                passengerDetails: passengerDetails,
                bookingMetadata: bookingMetadata,
                callback: callback
            )
        }
    }
    
    // MARK: - Properties

    var childCoordinators: [KarhooUISDKSceneCoordinator] = []
    var baseViewController: BaseViewController { viewController }
    private(set) var navigationController: UINavigationController?
    private(set) var viewController: RidePlanningViewController!
    private(set) var presenter: KarhooRidePlanningViewModel?

    private var callback: ((ScreenResult<KarhooRidePlanningResult>) -> Void)?

    // MARK: - Initializator

    init(
        navigationController: UINavigationController?,
        journeyInfo: JourneyInfo? = nil,
        passengerDetails: PassengerDetails? = nil,
        bookingMetadata: [String: Any]?,
        callback: @escaping (ScreenResult<KarhooRidePlanningResult>) -> Void
    ) {
        self.presenter = KarhooRidePlanningViewModel(
            journeyInfo: journeyInfo,
            passengerDetails: passengerDetails,
            bookingMetadata: bookingMetadata,
            router: self
        )
        self.viewController = KarhooRidePlanningViewController().then {
            $0.setupBinding(presenter!)
        }
        self.navigationController = navigationController ?? NavigationController(
            rootViewController: self.viewController,
            style: .primary
        )
        self.callback = callback
    }
}

extension KarhooRidePlanningCoordinator: RidePlanningRouter {
    func routeToAllocationScreen() {}
    
    func routeToSideMenu() {}
    
    func routeToDatePicker() {}
    
    func routeToQuoteList() {}
    
    func routeToCheckout() {}
}
