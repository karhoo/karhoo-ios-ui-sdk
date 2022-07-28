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
    var filters: [QuoteListFilter] { get }
    func viewDidLoad()
    func viewWillAppear()
    // Using this method pass all selected filters to the presenter. Every other filer of this category will not be active anymore.
    func filterSelected(_ filter: [QuoteListFilter], for category: QuoteListFilters.Category)
    func close(save: Bool)
    func resetFilter()
    func resultsCountForSelectedFilters() -> Int
}

protocol QuoteListFiltersRouter: AnyObject {
    func dismiss()
}

protocol QuoteFilterHandler: AnyObject {
    var numberOfPassangers: Int { get }
    var numberOfLuggages: Int { get }
    var filters: [QuoteListFilter] { get set }
    /// Filter given input using provided fitlers value
    func filter(_ quotes: [Quote], using filters: [QuoteListFilter]) -> [Quote]
    /// Filter given input using self.filters variable value
    func filter(_ quotes: [Quote]) -> [Quote]
}
