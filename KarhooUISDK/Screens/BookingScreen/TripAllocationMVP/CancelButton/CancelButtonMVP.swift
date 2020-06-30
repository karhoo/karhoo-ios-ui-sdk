//
//  CancelButtonMVP.swift
//  CancelButton
//
//
//  Copyright © 2018 Karhoo. All rights reserved.
//

import Foundation

protocol CancelButtonView {

    func reset()
}

protocol CancelButtonActions: AnyObject {

    func userRequestedTripCancellation()
}
