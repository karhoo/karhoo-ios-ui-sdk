//  
//  NewQuoteList+MVPR .swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK

protocol NewQuoteListViewController: BaseViewController {
}

protocol NewQuoteListPresenter: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
}

protocol NewQuoteListRouter {
}
