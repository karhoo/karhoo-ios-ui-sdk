//  
//  NewQuoteListBuilder.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

enum NewQuoteList {
    static func build(
        quotes: [Quote] = [],
        onQuoteSelected: @escaping (Quote) -> Void,
        onQuoteDetailsSelected: @escaping (Quote) -> Void
    ) -> NewQuoteListViewController {
        
        let viewController = KarhooNewQuoteListViewController()
        let router = KarhooNewQuoteListRouter(viewController: viewController)
        let presenter = KarhooNewQuoteListPresenter(
            router: router,
            quotes: quotes,
            onQuoteSelected: onQuoteSelected,
            onQuoteDetailsSelected: onQuoteDetailsSelected
        )

        viewController.setupBinding(presenter)

        return viewController
    }
}
