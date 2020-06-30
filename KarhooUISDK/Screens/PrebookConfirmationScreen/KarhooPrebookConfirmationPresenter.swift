//
//  KarhooPrebookConfirmationPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

final class KarhooPrebookConfirmationPresenter: PrebookConfirmationPresenter {

    private weak var confirmationView: PrebookConfirmationView?

    private let bookingDetails: BookingDetails
    private let quote: Quote
    private let callback: ScreenResultCallback<PrebookConfirmationAction>

    init(quote: Quote,
         bookingDetails: BookingDetails,
         callback: @escaping ScreenResultCallback<PrebookConfirmationAction>) {
        self.quote = quote
        self.bookingDetails = bookingDetails
        self.callback = callback
    }

    func load(view: PrebookConfirmationView) {
        confirmationView = view
        updateUI()
    }

    private func updateUI() {
        let viewModel = PrebookConfirmationViewModel(bookingDetails: bookingDetails,
                                                     quote: quote)
        confirmationView?.updateUI(withViewModel: viewModel)
    }

    func didTapScreen() {
        finishWithResult(.completed(result: .close))
    }

    func didTapPopupButton() {
        finishWithResult(.completed(result: .rideDetails))
    }

    func didTapClose() {
        finishWithResult(.completed(result: .close))
    }

    private func finishWithResult(_ result: ScreenResult<PrebookConfirmationAction>) {
        callback(result)
    }
}
