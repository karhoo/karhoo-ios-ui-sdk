//
//  JourneyOptionsMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol JourneyOptionsView {

    func set(actions: JourneyOptionsActions)

    func set(viewModel: JourneyOptionsViewModel)
}

protocol JourneyOptionsPresenter {

    func call(phoneNumber: String)
}

protocol JourneyOptionsActions: AnyObject {

    func cancelSelected()
}
