//
//  CountruCodeSelectionMVP.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 10.09.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

protocol CountryCodeSelectionActions {
    var preSelectedCountry: Country? { get set }
    func countrySelected(country: Country)
    func backClicked()
    func filterData(filter: String?) -> [Country]
}
