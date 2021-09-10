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
    private let callback: ScreenResultCallback<PassengerDetails>
    
    init(details: PassengerDetails?,
         callback: @escaping ScreenResultCallback<PassengerDetails>) {
        self.details = details
        self.callback = callback
    }
    
    func doneClicked(newDetails: PassengerDetails) {
        let result = ScreenResult.completed(result: newDetails)
        callback(result)
    }
    
    func backClicked() {
        let result = ScreenResult<PassengerDetails>.cancelled(byUser: true)
        callback(result)
    }
}
