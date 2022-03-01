//  
//  QuoteListTableBuilder.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

enum QuoteListTable {
    static func build(
        quotes: [Quote] = [],
        onQuoteSelected: @escaping (Quote) -> Void,
        onQuoteDetailsSelected: @escaping (Quote) -> Void
    ) -> QuoteListTableViewController {
        
        let viewController = KarhooQuoteListTableViewController()
        let router = KarhooQuoteListTableRouter(viewController: viewController)
        let presenter = KarhooQuoteListTablePresenter(
            router: router,
            quotes: quotes,
            onQuoteSelected: onQuoteSelected,
            onQuoteDetailsSelected: onQuoteDetailsSelected
        )

        viewController.setupBinding(presenter)

        return viewController
    }
}
