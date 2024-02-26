//
//  Country.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 13.09.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK
import UIKit

public struct Country: KarhooCodableModel {
    var name: String
    var phoneCode: String
    var code: String // The flags in Assets > CountryFlags have names corresponding to the the country code
    
    init(name: String, phoneCode: String, code: String) {
        self.name = name
        self.phoneCode = phoneCode
        self.code = code
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.phoneCode = try container.decode(String.self, forKey: .phoneCode)
        self.code = try container.decode(String.self, forKey: .code)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(phoneCode, forKey: .phoneCode)
        try container.encode(code, forKey: .code)
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case phoneCode = "phone_code"
        case code
    }
}

struct CountryPhoneRule: KarhooCodableModel {
    var countryCode: String
    var internationalPhonePrefix: String
    var nationalPhonePrefix: String = ""
    var mobileValidationRegex: String = "^\\+\\d{1,3}[ -]?\\d{3,11}$"
    var exampleMobileNumber: String = ""
    
    init(countryCode: String) {
        self.countryCode = countryCode
        internationalPhonePrefix = KarhooCountryParser.countryPhoneInternationalPrefixes[countryCode] ?? ""
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.countryCode = try container.decode(String.self, forKey: .countryCode)
        self.internationalPhonePrefix = KarhooCountryParser.countryPhoneInternationalPrefixes[countryCode] ?? ""
        self.mobileValidationRegex = try container.decode(String.self, forKey: .mobileValidationRegex)
        self.nationalPhonePrefix = try container.decode(String.self, forKey: .nationalPhonePrefix)
        self.exampleMobileNumber = try container.decode(String.self, forKey: .exampleMobileNumber)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(countryCode, forKey: .countryCode)
        try container.encode(mobileValidationRegex, forKey: .mobileValidationRegex)
        try container.encode(nationalPhonePrefix, forKey: .nationalPhonePrefix)
        try container.encode(exampleMobileNumber, forKey: .exampleMobileNumber)
    }
    
    enum CodingKeys: String, CodingKey {
        case countryCode = "country_code"
        case mobileValidationRegex = "mobile_validation_rule"
        case nationalPhonePrefix = "national_prefix"
        case exampleMobileNumber = "example_mobile_number"
    }
}
