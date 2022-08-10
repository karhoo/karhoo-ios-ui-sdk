//
//  BookingRouter.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 04.03.2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

class KarhooBookingRouter: BookingRouter {

    weak var viewController: BaseViewController?
    var checkoutScreenBuilder: CheckoutScreenBuilder?

    func routeToQuoteList(
        details: JourneyDetails,
        onQuoteSelected: @escaping (_ quote: Quote,  _ journeyDetails: JourneyDetails) -> Void
    ) {
        guard let navigationController = viewController?.navigationController else {
            assertionFailure()
            return
        }

        let quoteListCoordinator = KarhooComponents.shared.quoteList(
            navigationController: navigationController,
            journeyDetails: details,
            onQuoteSelected: onQuoteSelected
        )
        if viewController?.navigationController?.topViewController == viewController {
            if #available(iOS 13.0, *) {
                // navigation bar for ios 13+ configured in QuoteListViewController:setupNavigationBar() function
            } else {
                let backArrow = UIImage.uisdkImage("back_arrow")
                let navigationBarColor = KarhooUI.colors.primary
                viewController?.navigationController?.navigationBar.barTintColor = navigationBarColor
                viewController?.navigationController?.navigationBar.backIndicatorImage = backArrow
                viewController?.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backArrow
                viewController?.navigationController?.navigationBar.titleTextAttributes = [
                    .foregroundColor: KarhooUI.colors.white
                ]
                viewController?.navigationItem.title = ""
            }
        }

        quoteListCoordinator.start()
    }

    func routeToCheckout(
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]?,
        bookingRequestCompletion: @escaping (ScreenResult<TripInfo>, Quote, JourneyDetails) -> Void
    ) {
        guard let builder = checkoutScreenBuilder else {
            assertionFailure()
            return
        }
        let checkoutView = builder
            .buildCheckoutScreen(
                quote: quote,
                journeyDetails: journeyDetails,
                bookingMetadata: bookingMetadata,
                callback: { result in
                    bookingRequestCompletion(result, quote, journeyDetails)
                }
            )

        viewController?.push(checkoutView)
    }
}
