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
    var details: PassengerDetails?
    private let callback: ScreenResultCallback<PassengerDetailsResult>
    
    init(details: PassengerDetails?,
         callback: @escaping ScreenResultCallback<PassengerDetailsResult>) {
        self.details = details
        self.callback = callback
    }
    
    func doneClicked(newDetails: PassengerDetails, country: Country) {
        let data = PassengerDetailsResult(details: newDetails, country: country)
        let result = ScreenResult.completed(result: data)
        callback(result)
    }
    
    func backClicked() {
        let result = ScreenResult<PassengerDetailsResult>.cancelled(byUser: true)
        callback(result)
    }
}
