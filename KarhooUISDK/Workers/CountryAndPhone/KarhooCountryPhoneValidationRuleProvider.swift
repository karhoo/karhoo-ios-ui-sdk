//
//  KarhooCountryPhoneValidationRuleProvider.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 10.07.2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation

protocol CountryPhoneValidationRuleProvider {
    func getRule(for countryCode: String) -> CountryPhoneRule
}

class KarhooCountryPhoneValidationRuleProvider: CountryPhoneValidationRuleProvider {
    static let shared = KarhooCountryPhoneValidationRuleProvider()
    
    var rules: [CountryPhoneRule] = []
    let defaultRule = CountryPhoneRule(countryCode: "")
    
    private init() {
        do {
            if let list: [CountryPhoneRule] = KarhooFileManager.getFromFile("country_phone_validation_rules") {
                rules = list
            }
        }
    }
    
    func getRule(for countryCode: String) -> CountryPhoneRule {
        rules.first(where: { $0.countryCode == countryCode }) ?? defaultRule
    }
}
