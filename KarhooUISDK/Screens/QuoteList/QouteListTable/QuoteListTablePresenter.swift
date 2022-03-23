//  
//  QuoteListTablePresenter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

class KarhooQuoteListTablePresenter: QuoteListTablePresenter {

    private let router: QuoteListTableRouter
    let onQuoteSelected: (Quote) -> Void
    let onQuoteDetailsSelected: (Quote) -> Void
    var onQuoteListStateUpdated: ((QuoteListState) -> Void)?
    var state: QuoteListState

    init(
        router: QuoteListTableRouter,
        initialState: QuoteListState = .loading,
        onQuoteSelected: @escaping (Quote) -> Void,
        onQuoteDetailsSelected: @escaping (Quote) -> Void
    ) {
        self.router = router
        self.state = initialState
        self.onQuoteSelected = onQuoteSelected
        self.onQuoteDetailsSelected = onQuoteDetailsSelected
    }

    func viewDidLoad() {
    }

    func viewWillAppear() {
        onQuoteListStateUpdated?(state)
    }

    func updateQuoteListState(_ state: QuoteListState) {
        self.state = state
        onQuoteListStateUpdated?(state)
    }

    func getErrorViewModel() -> QuoteListTableErrorViewModel {
        QuoteListTableErrorViewModel(
            title: titleForPresentedError(),
            message: messageForPresentedError(),
            attributedMessage: attributedMessageForPresentedError(),
            imageName: imageNameForPresentedError(),
            actionTitle: actionTitleForPresentedError(),
            actionCallback: actionForPresentedError()
        )
    }

    // MARK: - Build error view model helper methods

    private func titleForPresentedError() -> String {
        switch state {
        case .empty(reason: .noResults):
            return UITexts.Errors.errorNoAvailabilityForTheRequestTimeTitle
        case .empty(reason: .originAndDestinationAreTheSame):
            return UITexts.Quotes.errorPickupAndDestinationSameTitle
        default:
            return ""
        }
    }

    private func messageForPresentedError() -> String? {
        switch state {
        case .empty(reason: .noResults):
            return UITexts.Errors.errorNoAvailabilityForTheRequestTimeMessage
        case .empty(reason: .originAndDestinationAreTheSame):
            return UITexts.Quotes.errorPickupAndDestinationSameMessage
        default:
            return nil
        }
    }

    private func attributedMessageForPresentedError() -> NSAttributedString? {
        switch state {
        default:
            return nil
        }
    }

    private func imageNameForPresentedError() -> String {
        switch state {
        case .empty(reason: .noResults):
            return "quoteList_error_no_availability"
        default:
            return "quoteList_error_no_availability"
        }
    }

    private func actionTitleForPresentedError() -> String? {
        switch state {
        default:
            return nil
        }
    }

    private func actionForPresentedError() -> (() -> Void)? {
        switch state {
        default:
            return nil
        }
    }

}
