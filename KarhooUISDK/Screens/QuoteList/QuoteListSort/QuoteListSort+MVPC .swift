//  
//  QuoteListSort+MVPC .swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/03/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK

protocol QuoteListSortCoordinator: KarhooUISDKSceneCoordinator {
    var viewController: QuoteListSortViewController { get }
}

protocol QuoteListSortViewController: BaseViewController {
    func setupBinding(_ presenter: QuoteListSortPresenter)
}

protocol QuoteListSortPresenter: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func close(save: Bool)
}

protocol QuoteListSortRouter: AnyObject {
    func dismiss()
}
