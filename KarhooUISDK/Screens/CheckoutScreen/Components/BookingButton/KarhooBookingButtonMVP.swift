//
//  BookingButtonMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol BookingButtonView {
    func set(actions: BookingButtonDelegate)
    func setDisabledMode()
    func setRequestMode()
    func setRequestingMode()
    func setRequestedMode()
}

protocol BookingButtonDelegate: AnyObject {
    func requestPressed()
    func addMoreDetails()
}
