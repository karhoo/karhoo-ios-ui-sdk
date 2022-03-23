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
        case .empty(reason: .noAvailabilityInRequestedArea):
            return "No fleets in this area yet" //UITexts.Errors.errorNoAvailabilityInRequestedAreaTitle
        default:
            return ""
        }
    }

    private func messageForPresentedError() -> String? {
        switch state {
        case .empty(reason: .noResults):
            return UITexts.Errors.errorNoAvailabilityForTheRequestTimeMessage
        case .empty(reason: .noAvailabilityInRequestedArea):
            return nil // for this case we are showing attributedMessageForPresentedError
        default:
            return nil
        }
    }

    private func attributedMessageForPresentedError() -> NSAttributedString? {
        switch state {
        case .empty(reason: .noAvailabilityInRequestedArea):
            return getAttributedStringForNoCoverageError()
        default:
            return nil
        }
    }

    private func imageNameForPresentedError() -> String {
        switch state {
        case .empty(reason: .noResults):
            return "quoteList_error_no_availability"
        case .empty(reason: .noAvailabilityInRequestedArea):
            return "quoteList_error_no_coverage"
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

    private func getAttributedStringForNoCoverageError() -> NSAttributedString {
        let contactUsText = "Contact us"
        let contactUsLink = "https://karhoo.com"
        let message = "%1$@ to suggest news fleets"// UITexts.Errors.errorNoAvailabilityInRequestedAreaMessage

        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: KarhooUI.fonts.bodyRegular(),
            .foregroundColor: KarhooUI.colors.text
        ]

        let linkAttributes: [NSAttributedString.Key: Any] = [
            .font: KarhooUI.fonts.bodyRegular(),
            .link: contactUsLink,
            .foregroundColor: KarhooUI.colors.accent,
            .underlineColor: KarhooUI.colors.accent,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]

        let attrText = NSMutableAttributedString()
        let fullText = String(format: NSLocalizedString(message,
            comment: ""), contactUsText)
        attrText.append(NSAttributedString(string: fullText, attributes: regularAttributes))
        let contactUsRange = (attrText.string as NSString).range(of: contactUsText)
        attrText.addAttributes(linkAttributes, range: contactUsRange)
        return attrText
    }
}
