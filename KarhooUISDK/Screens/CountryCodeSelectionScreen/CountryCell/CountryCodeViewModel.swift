//
//  CountryCodeViewModel.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 10.09.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit

final class CountryCodeViewModel {
    var countryCode: String
    var phoneCode: String
    var countryName: String
    var isSelected: Bool
    
    var printedCountryInfo: String {
        return "\(countryName) \(phoneCode)"
    }
    
    var isSelectedImage: UIImage {
        return isSelected ?
            UIImage.uisdkImage("kh_field_success").coloured(withTint: KarhooUI.colors.primary) :
            UIImage.uisdkImage("kh_circle").coloured(withTint: KarhooUI.colors.infoBackgroundColor)
    }
    
    var flagImage: UIImage {
        return UIImage.uisdkImage("\(countryCode).png")
    }
    
    init(country: Country, isSelected: Bool) {
        self.countryCode = country.code
        self.phoneCode = country.phoneCode
        self.countryName = country.name
        self.isSelected = isSelected
    }
}
