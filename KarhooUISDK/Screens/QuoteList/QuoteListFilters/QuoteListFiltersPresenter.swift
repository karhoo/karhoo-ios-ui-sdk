//  
//  QuoteListFiltersPresenter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 28/04/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

class KarhooQuoteListFiltersPresenter: QuoteListFiltersPresenter {

    private let router: QuoteListFiltersRouter
    private let onResultsForFiltersChosen: (QuoteListSelectedFiltersModel) -> Int
    private let onFiltersConfirmed: (QuoteListSelectedFiltersModel) -> Void
    private var selectedFilters: QuoteListSelectedFiltersModel = .default()

    init(
        router: QuoteListFiltersRouter,
        onResultsForFiltersChosen: @escaping (QuoteListSelectedFiltersModel) -> Int,
        onFiltersConfirmed: @escaping (QuoteListSelectedFiltersModel) -> Void
    ) {
        self.router = router
        self.onResultsForFiltersChosen = onResultsForFiltersChosen
        self.onFiltersConfirmed = onFiltersConfirmed
    }

    func viewDidLoad() {
    }

    func viewWillAppear() {
    }

//    func filterSelected(_ filter: QuoteListFilter) {
//    }

    func close(save: Bool) {
        if save {
            onFiltersConfirmed(selectedFilters)
        }
        router.dismiss()
    }
}

struct QuoteListSelectedFiltersModel {
    init(numberOfLuggages: Int, numberOfPassengers: Int, vehicleTypes: String, vehicleClasses: String) {
        self.numberOfLuggages = numberOfLuggages
        self.numberOfPassengers = numberOfPassengers
        self.vehicleTypes = vehicleTypes
        self.vehicleClasses = vehicleClasses
    }
    
    let numberOfLuggages: Int
    let numberOfPassengers: Int
    let vehicleTypes: String
    let vehicleClasses: String
    
    static func `default`() -> QuoteListSelectedFiltersModel {
        QuoteListSelectedFiltersModel(
            numberOfLuggages: 0,
            numberOfPassengers: 1,
            vehicleTypes: "",
            vehicleClasses: ""
        )
    }
}
