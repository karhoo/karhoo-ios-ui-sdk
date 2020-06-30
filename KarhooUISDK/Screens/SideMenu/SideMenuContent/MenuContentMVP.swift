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
    func feedbackPressed()
    func helpPressed()
    func bookingsPressed()
    func aboutPressed()
}

protocol MenuContentView: AnyObject, FlowItemable {}
