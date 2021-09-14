//
//  CountryCodeSelectionPresenter.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 10.09.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class CountryCodeSelectionPresenter: CountryCodeSelectionActions {
    var preSelectedCountry: Country?
    private let callback: ScreenResultCallback<Country>
    private let data: [Country]!
    
    init(preSelectedCountry: Country?,
         callback: @escaping ScreenResultCallback<Country>) {
        self.preSelectedCountry = preSelectedCountry
        self.callback = callback
        self.data = KarhooCountryParser.getCountries()
    }
    
    func backClicked() {
        callback(ScreenResult.cancelled(byUser: true))
    }
    
    func countrySelected(country: Country) {
        callback(ScreenResult.completed(result: country))
    }
    
    func filterData(filter: String?) -> [Country] {
        guard var filter = filter, !filter.isEmpty, filter != " "
        else {
            return data
        }
        
        filter = filter.trimmingCharacters(in: .whitespacesAndNewlines)
        let filtered = data.filter({ $0.name.contains(filter) })
        return filtered
    }
}
