//  
//  QuoteListTableRouter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

struct KarhooQuoteListTableRouter: QuoteListTableRouter {
    private var viewController: BaseViewController

    init(viewController: BaseViewController) {
        self.viewController = viewController
    }
}
