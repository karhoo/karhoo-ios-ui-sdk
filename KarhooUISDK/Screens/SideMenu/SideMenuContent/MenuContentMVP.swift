//
//  MenuContentMVP.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol MenuContentPresenter {
    func profilePressed()
    func aboutPressed()
    func bookingsPressed()
    func helpPressed()
    func checkGuestAuthentication()
}

@objc public protocol MenuContentView: AnyObject, FlowItemable {
    func showGuestMenu()
}
