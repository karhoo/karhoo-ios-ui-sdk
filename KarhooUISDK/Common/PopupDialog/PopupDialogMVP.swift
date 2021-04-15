//
//  PopupDialogPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol PopupDialogPresenter {
    func didTapScreen()
    func didTapPopupButton()
    func load(view: PopupDialogView)
}

protocol PopupDialogView: AnyObject {
    func set(dialogMessage: String)
    func set(dialogTitle: String)
    func set(formButtonTitle: String)
}
