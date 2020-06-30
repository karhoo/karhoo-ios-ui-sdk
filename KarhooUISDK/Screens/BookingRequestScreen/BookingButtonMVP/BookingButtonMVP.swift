//
//  BookingButtonMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol BookingButtonView {

    func set(actions: BookingButtonActions)

    func setDisabledMode()
    
    func setRequestMode()

    func setRequestingMode()

    func setRequestedMode()

    func setAddFlightDetailsMode()
}

protocol BookingButtonActions: AnyObject {

    func requestPressed()

    func addFlightDetailsPressed()
}
