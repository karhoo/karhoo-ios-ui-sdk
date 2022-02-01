//
//  PassengerDetails+Extensions.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 15.10.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

extension PassengerDetails {
    public var areValid: Bool {
        get {
            guard Utils.isValidName(name: firstName),
                  Utils.isValidName(name: lastName),
                  Utils.isValidEmail(email: email),
                  Utils.isValidPhoneNumber(number: phoneNumber),
                  !locale.isEmpty
            else {
                return false
            }
            
            return true
        }
    }
}
