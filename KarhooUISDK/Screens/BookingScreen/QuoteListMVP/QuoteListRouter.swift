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

    func routeToQuote(_ quote: Quote) {
        // TODO: finish implementation
    }

    func routeToQuoteDetails(_ quote: Quote) {
        // TODO: finish implementation
    }
}
