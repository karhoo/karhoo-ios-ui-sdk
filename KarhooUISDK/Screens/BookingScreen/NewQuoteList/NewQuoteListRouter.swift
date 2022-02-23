//  
//  NewQuoteListRouter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

struct KarhooNewQuoteListRouter: NewQuoteListRouter {
    private var viewController: BaseViewController

    init(viewController: BaseViewController) {
        self.viewController = viewController
    }

    // Example routing method
    /**
    func routeToSample(sampleObject: Any) {
        let targetViewController = SampleViewController(with: sampleObject)
        viewController.show(targetViewController)
    }
     */
}
