//
//  QuoteListRouter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 25/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

struct KarhooQuoteListRouter: QuoteListRouter {
    private var viewController: BaseViewController

    init(viewController: BaseViewController) {
        self.viewController = viewController
    }

    func routeToQuote(_ quote: Quote, journeyDetails: JourneyDetails) {
    let checkoutScreenBuilder: CheckoutScreenBuilder = UISDKScreenRouting.default.checkout()
        
        let checkoutView = checkoutScreenBuilder
            .buildCheckoutScreen(
                quote: quote,
                journeyDetails: journeyDetails,
                bookingMetadata: KarhooUISDKConfigurationProvider.configuration.bookingMetadata,
                callback: {_ in
//                TODO: Add ecpected bahaviour, previously implemented in KarhooBookingPresenter.bookingRequestCompleted
                    return}
               /* callback: { [weak self] result in
                   self?.view?.dismiss(animated: false, completion: {
                        self?.bookingRequestCompleted(
                            result: result,
                            quote: quote,
                            details: journeyDetails
                        )
                    })
                }*/
            )
        viewController.navigationController?.setNavigationBarHidden(true, animated: false)
        viewController.push(checkoutView)
        // TODO: finish implementation
    }

    func routeToQuoteDetails(_ quote: Quote) {
        // TODO: finish implementation
    }
}
