//  
//  QuoteListFilters+MVPC .swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 28/04/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK

protocol QuoteListFiltersCoordinator: KarhooUISDKSceneCoordinator {
    var viewController: QuoteListFiltersViewController { get }
}

protocol QuoteListFiltersViewController: BaseViewController {
    func setupBinding(_ presenter: QuoteListFiltersPresenter)
}

protocol QuoteListFiltersPresenter: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func close(save: Bool)
}

protocol QuoteListFiltersRouter: AnyObject {
    func dismiss()
}
