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

    func currentUserAsPassenger() -> PassengerDetails? {
        if Karhoo.configuration.authenticationMethod().isGuest() {
            return nil
        }

        guard let currentUser = Karhoo.getUserService().getCurrentUser() else {
            return nil
        }

        return PassengerDetails(user: currentUser)
    }
}
