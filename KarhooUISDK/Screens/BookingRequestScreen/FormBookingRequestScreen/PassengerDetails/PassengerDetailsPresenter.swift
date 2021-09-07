//
//  PassengerDetailsPresenter.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 25.08.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

class PassengerDetailsPresenter: PassengerDetailsPresenterProtocol {
    var details: PassengerDetails?
    var callback: (PassengerDetailsResult) -> ()
    
    init(details: PassengerDetails?,
        callback: @escaping (PassengerDetailsResult) -> ()) {
        self.details = details
        self.callback = callback
    }
    
    func doneClicked(newDetails: PassengerDetails) {
        callback(PassengerDetailsResult(details: newDetails, isCancelled: false))
    }
    
    func backClicked() {
        callback(PassengerDetailsResult(details: nil, isCancelled: true))
    }
}
