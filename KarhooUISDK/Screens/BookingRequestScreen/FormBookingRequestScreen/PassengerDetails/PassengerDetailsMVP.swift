//
//  PassengerDetailsMVP.swift
//  KarhooUISDK
//
//  Created by Jeevan Thandi on 08/07/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

protocol PassengerDetailsActions: class {
    func passengerDetailsValid(_ : Bool)
}

protocol PassengerDetailsViewP: UIView {

    func getPassengerDetails() -> PassengerDetails
}
