//
//  KarhooAddPassengerDetailsMVP.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 26.08.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

protocol AddPassengerDetailsViewDelegate: AnyObject {
    func willUpdatePassengerDetails()
    func didUpdatePassengerDetails(details: PassengerDetails?)
}

protocol AddPassengerDetailsPresenter {
    func set(details: PassengerDetails?)
}
