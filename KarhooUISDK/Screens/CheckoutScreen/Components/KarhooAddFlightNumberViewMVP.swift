//
//  KarhooAddFlightNumberViewMVP.swift
//
//
//  Created by Bartlomiej Sopala on 05/01/2023.
//

import Foundation
import KarhooSDK

protocol AddFlightNumberViewDelegate: AnyObject {
    func willUpdateFlightNumber()
    func didUpdateFlightNumber(_ flightNumber: String)
}

protocol AddFlightNumberPresenter {
    func set(flightNumber: String)
}

