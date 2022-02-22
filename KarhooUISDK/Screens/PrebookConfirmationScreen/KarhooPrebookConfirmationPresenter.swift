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

    private let journeyDetails: JourneyDetails
    private let quote: Quote
    private let callback: ScreenResultCallback<PrebookConfirmationAction>

    init(quote: Quote,
         journeyDetails: JourneyDetails,
         callback: @escaping ScreenResultCallback<PrebookConfirmationAction>) {
        self.quote = quote
        self.journeyDetails = journeyDetails
        self.callback = callback
    }

    func load(view: PrebookConfirmationView) {
        confirmationView = view
        updateUI()
    }

    private func updateUI() {
        let viewModel = PrebookConfirmationViewModel(journeyDetails: journeyDetails,
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
