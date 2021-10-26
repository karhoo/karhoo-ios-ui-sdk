//
//  PassengerDetailsMVP.swift
//  KarhooUISDK
//
//  Created by Jeevan Thandi on 08/07/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

protocol PassengerDetailsActions: BaseViewController {
    func passengerDetailsValid(_ : Bool)
}

protocol PassengerDetailsPresenterProtocol {
    var details: PassengerDetails? { get set }
    func doneClicked(newDetails: PassengerDetails, country: Country)
    func backClicked()
}

struct PassengerDetailsResult {
    var details: PassengerDetails?
    var country: Country?
}
