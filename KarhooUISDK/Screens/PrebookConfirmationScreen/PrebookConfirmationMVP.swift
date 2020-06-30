//
//  PrebookConfirmationMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol PrebookConfirmationView: AnyObject {
    func updateUI(withViewModel viewModel: PrebookConfirmationViewModel)
}

protocol PrebookConfirmationPresenter {
    func load(view: PrebookConfirmationView)

    func didTapScreen()
    func didTapClose()
    func didTapPopupButton()
}

public enum PrebookConfirmationAction {
    case close
    case rideDetails
}
