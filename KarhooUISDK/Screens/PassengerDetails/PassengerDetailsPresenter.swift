//
//  PassengerDetailsPresenter.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 25.08.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

final class PassengerDetailsPresenter: PassengerDetailsPresenterProtocol {
    weak var delegate: PassengerDetailsDelegate?
    
    func doneClicked(newDetails: PassengerDetails, country: Country) {
        let result = PassengerDetailsResult(details: newDetails, country: country)
        delegate?.didInputPassengerDetails(result: result)
    }
    
    func backClicked() {
        delegate?.didCancelInput(byUser: true)
    }
}
