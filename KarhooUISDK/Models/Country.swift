//
//  Country.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 13.09.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit
import KarhooSDK

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
