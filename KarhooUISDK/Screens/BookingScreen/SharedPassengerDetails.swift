//
//  SharedPassengerDetails.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK

class PassengerInfo {

    static let shared = PassengerInfo()

    var passengerDetails: PassengerDetails?

    func set(details: PassengerDetails?) {
        passengerDetails = details
    }
}
