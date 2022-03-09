//
//  QuoteListCoordinator.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 06/03/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit

final class KarhooQuoteListCoordinator: QuoteListCoordinator {

    // MARK: - Properties

    var childCoordinators: [KarhooUISDKSceneCoordinator] = []
    var baseViewController: BaseViewController { viewController }
    private(set) var navigationController: UINavigationController?
    private(set) var viewController: QuoteListViewController!
    private(set) var presenter: QuoteListPresenter!

    var onQuoteSelected: ((Quote) -> Void)?

    // MARK: - Initializator

    init(
        navigationController: UINavigationController?,
        journeyDetails: JourneyDetails? = nil,
        quoteService: QuoteService = Karhoo.getQuoteService(),
        quoteSorter: QuoteSorter = KarhooQuoteSorter(),
        analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics(),
        onQuoteSelected: ((Quote) -> Void)?
    ) {
        self.navigationController = navigationController
        self.viewController = KarhooQuoteListViewController()
        self.presenter = KarhooQuoteListPresenter(
            journeyDetails: journeyDetails,
            router: self,
            journeyDetailsManager: KarhooJourneyDetailsManager.shared,
            quoteService: quoteService,
            quoteSorter: quoteSorter,
            analytics: analytics
        )
        self.onQuoteSelected = onQuoteSelected
        self.viewController.setupBinding(presenter)
    }

    // MARK: - Start & routing

    func start() {
        navigationController?.show(viewController, sender: nil)
    }
}

extension KarhooQuoteListCoordinator: QuoteListRouter {

    func routeToQuote(_ quote: Quote, journeyDetails: JourneyDetails) {
        // TODO: replace to use Booking coordinator to perform actual navigation
//        let checkoutScreenBuilder: CheckoutScreenBuilder = UISDKScreenRouting.default.checkout()
//
//        let checkoutView = checkoutScreenBuilder
//            .buildCheckoutScreen(
//                quote: quote,
//                journeyDetails: journeyDetails,
//                bookingMetadata: KarhooUISDKConfigurationProvider.configuration.bookingMetadata,
//                callback: {_ in
////                TODO: Add ecpected bahaviour, previously implemented in KarhooBookingPresenter.bookingRequestCompleted
//                    return}
//               /* callback: { [weak self] result in
//                   self?.view?.dismiss(animated: false, completion: {
//                        self?.bookingRequestCompleted(
//                            result: result,
//                            quote: quote,
//                            details: journeyDetails
//                        )
//                    })
//                }*/
//            )
//        navigationController?.setNavigationBarHidden(true, animated: false)
//        navigationController?.show(checkoutView, sender: nil)
//        // TODO: finish implementation

        onQuoteSelected?(quote)
    }

    func routeToQuoteDetails(_ quote: Quote) {
        // TODO: finish implementation
    }
}
