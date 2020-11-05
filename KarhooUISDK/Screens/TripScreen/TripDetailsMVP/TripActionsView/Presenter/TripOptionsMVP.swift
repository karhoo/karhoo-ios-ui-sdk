//
//  TripOptionsMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol TripOptionsView {

    func set(actions: TripOptionsActions)

    func set(viewModel: TripOptionsViewModel)
}

protocol TripOptionsPresenter {

    func call(phoneNumber: String)
}

protocol TripOptionsActions: AnyObject {

    func cancelSelected()
}
