//
//  BaseFarePopupDialogPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation

final class KarhooPopupDialogPresenter: PopupDialogPresenter {

    private weak var view: PopupDialogView?
    private let callback: ScreenResultCallback<Void>

    init(callback: @escaping ScreenResultCallback<Void>) {
        self.callback = callback
    }

    func load(view: PopupDialogView) {
        self.view = view
        view.set(formButtonTitle: UITexts.Generic.gotIt)
        view.set(dialogMessage: UITexts.Booking.baseFareExplanation)
        view.set(dialogTitle: UITexts.Booking.baseFare)
    }

    func didTapScreen() {
        finishWithResult(.cancelled(byUser: true))
    }

    func didTapPopupButton() {
        finishWithResult(.cancelled(byUser: true))
    }

    private func finishWithResult(_ : ScreenResult<Void>) {
        callback(.cancelled(byUser: true))
    }
}
