//
//  RidePlanning+MVVMC.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 04.04.2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

public protocol RidePlanningCoordinator: KarhooUISDKSceneCoordinator {
}

protocol RidePlanningViewController: BaseViewController {
    func set(leftNavigationButton: NavigationBarItemIcon)
    func set(sideMenu: SideMenu)
}

protocol RidePlanningRouter: AnyObject {
    func exitPressed()
    func routeToAllocationScreen()
    func routeToDatePicker()
    
    func routeToQuoteList(
        details: JourneyDetails,
        onQuoteSelected: @escaping (_ quote: Quote, _ journeyDetails: JourneyDetails) -> Void
    )

    func routeToCheckout(
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]?,
        bookingRequestCompletion: @escaping (ScreenResult<KarhooCheckoutResult>, Quote, JourneyDetails) -> Void
    )
}

public enum KarhooRidePlanningResult {
    case tripAllocated(tripInfo: TripInfo)
    case prebookConfirmed(tripInfo: TripInfo)
    case bookingFailed(error: KarhooError)
}
