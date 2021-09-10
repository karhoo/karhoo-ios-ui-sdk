//
//  CountryCodeSelectionPresenter.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 10.09.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class CountryCodeSelectionPresenter: CountryCodeSelectionActions {
    private let preSelectedCountry: Country?
    private let callback: ScreenResultCallback<Country>
    
    init(preSelectedCountry: Country?,
         callback: @escaping ScreenResultCallback<Country>) {
        self.preSelectedCountry = preSelectedCountry
        self.callback = callback
    }
    
    func backClicked() {
        callback(ScreenResult.cancelled(byUser: true))
    }
    
    func countrySelected(country: Country) {
        callback(ScreenResult.completed(result: country))
    }
}
