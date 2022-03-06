//
//  BookingRouter.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 04.03.2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

class KarhooBookingRouter: BookingRouter {
    
    func routeToQuoteList(from view: BaseViewController, details: JourneyDetails) {
        guard let navigationController = view.navigationController else {
            assertionFailure()
            return
        }

        let quoteListCoordinator = KarhooComponents.shared.quoteList(
            navigationController: navigationController,
            journeyDetails: details
        )
        if view.navigationController?.topViewController == view {
            if #available(iOS 13.0, *) {
                // navigation bar for ios 13+ configured in QuoteListViewController:setupNavigationBar() function
            } else {
                let backArrow = UIImage.uisdkImage("back_arrow")
                let navigationBarColor = KarhooUI.colors.primary
                view.navigationController?.navigationBar.barTintColor = navigationBarColor
                view.navigationController?.navigationBar.backIndicatorImage = backArrow
                view.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backArrow
                view.navigationItem.title = ""
            }
            quoteListCoordinator.start()
        }
    }
}
