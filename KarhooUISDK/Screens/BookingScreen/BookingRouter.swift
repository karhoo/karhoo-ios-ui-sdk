//
//  BookingRouter.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 04.03.2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit

class KarhooBookingRouter: BookingRouter {

    weak var viewController: BaseViewController?
    var checkoutScreenBuilder: CheckoutScreenBuilder?

    func routeToQuoteList(
        details: JourneyDetails,
        onQuoteSelected: @escaping (_ quote: Quote, _ journeyDetails: JourneyDetails) -> Void
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

        quoteListCoordinator.start()
    }

    func routeToCheckout(
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]?,
        bookingRequestCompletion: @escaping (ScreenResult<KarhooCheckoutResult>, Quote, JourneyDetails) -> Void
    ) {
        guard let navigationController = viewController?.navigationController else {
            assertionFailure()
            return
        }

        let checkoutCoordinator = KarhooComponents.shared.checkout(
            navigationController: navigationController,
            quote: quote,
            journeyDetails: journeyDetails,
            bookingMetadata: bookingMetadata,
            callback: { result in
                bookingRequestCompletion(result, quote, journeyDetails)
            }
        )

        checkoutCoordinator.start()
    }
}
