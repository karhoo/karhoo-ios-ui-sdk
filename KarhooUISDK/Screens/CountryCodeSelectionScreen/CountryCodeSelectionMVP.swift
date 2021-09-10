//
//  CountruCodeSelectionMVP.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 10.09.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

protocol CountryCodeSelectionActions {
    func countrySelected(country: Country)
    func backClicked()
}

struct Country {
    var name: String
    var phoneCode: String
    var code: String // The flags in Assets > CountryFlags have names corresponding to the the country code
    
    init(name: String, phoneCode: String, code: String) {
        self.name = name
        self.phoneCode = phoneCode
        self.code = code
    }
    
    var flag: UIImage? {
        return UIImage(named: code, in: Bundle(for: CountryCodeSelectionViewController.self), compatibleWith: nil)
    }
}
