//
//  CountryCodeViewModel.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 10.09.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

final class CountryCodeViewModel {
    var flagName: String
    var countryName: String
    var isSelected: Bool
    
    init(flagName: String, countryName: String, isSelected: Bool) {
        self.flagName = flagName
        self.countryName = countryName
        self.isSelected = isSelected
    }
}
