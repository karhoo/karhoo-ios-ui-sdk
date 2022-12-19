//
//  QuoteListTablePresenter.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit

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

    func getEmptyReasonViewModel() -> QuoteListTableErrorViewModel {
        QuoteListTableErrorViewModel(
            title: titleForPresentedEmptyResult(),
            message: messageForPresentedEmptyResult(),
            attributedMessage: attributedMessageForPresentedEmptyResult(),
            imageName: imageNameForPresentedEmptyResult(),
            actionTitle: actionTitleForPresentedEmptyResult(),
            actionCallback: actionForPresentedEmptyResult()
        )
    }

    // MARK: - Build error view model helper methods

    private func titleForPresentedEmptyResult() -> String {
        switch state {
        case .empty(reason: .noResults):
            return UITexts.Errors.errorNoAvailabilityForTheRequestTimeTitle
        case .empty(reason: .originAndDestinationAreTheSame):
            return UITexts.Errors.errorPickupAndDestinationSameTitle
        case .empty(reason: .noAvailabilityInRequestedArea):
            return UITexts.KarhooError.K3002
        case .empty(reason: .noQuotesAfterFiltering):
            return UITexts.Errors.errorNoResultsForFilterTitle
        case .empty(reason: .destinationOrOriginEmpty):
            return UITexts.Errors.errorDestinationOrOriginEmptyTitle
        default:
            return ""
        }
    }

    private func messageForPresentedEmptyResult() -> String? {
        switch state {
        case .empty(reason: .noResults):
            return UITexts.Errors.errorNoAvailabilityForTheRequestTimeMessage
        case .empty(reason: .originAndDestinationAreTheSame):
            return UITexts.Errors.errorPickupAndDestinationSameMessage
        case .empty(reason: .noAvailabilityInRequestedArea):
            return nil // for this case we are showing attributedMessageForPresentedError
        case .empty(reason: .noQuotesAfterFiltering):
            return UITexts.Errors.errorNoResultsForFilterMessage
        case .empty(reason: .destinationOrOriginEmpty):
            return UITexts.Errors.errorDestinationOrOriginEmptyMessage
        default:
            return nil
        }
    }

    private func attributedMessageForPresentedEmptyResult() -> NSAttributedString? {
        switch state {
        case .empty(reason: .noAvailabilityInRequestedArea):
            return getAttributedStringForNoCoverageEmptyResult()
        default:
            return nil
        }
    }

    private func imageNameForPresentedEmptyResult() -> String {
        switch state {
        case .empty(reason: .noResults):
            return "kh_uisdk_quote_list_error_no_availability"
        case .empty(reason: .noQuotesAfterFiltering):
            return "kh_uisdk_quote_list_error_no_results_for_filter"
        case .empty(reason: .originAndDestinationAreTheSame):
            return "kh_quote_list_error_pickup_destination_similar"
        case .empty(reason: .noAvailabilityInRequestedArea):
            return "kh_uisdk_quote_list_error_no_coverage"
        case .empty(reason: .destinationOrOriginEmpty):
            return "kh_quote_list_error_pickup_destination_similar"
        default:
            return "kh_uisdk_quote_list_error_no_availability"
        }
    }

    private func actionTitleForPresentedEmptyResult() -> String? {
        switch state {
        default:
            return nil
        }
    }

    private func actionForPresentedEmptyResult() -> (() -> Void)? {
        switch state {
        default:
            return nil
        }
    }

    private func getAttributedStringForNoCoverageEmptyResult() -> NSAttributedString {
        let contactUsText = UITexts.Errors.errorNoAvailabilityInRequestedAreaContactUsLinkText
        let contactUsLink = "OpenContactUsMail"
        let message = UITexts.Errors.errorNoAvailabilityInRequestedAreaContactUsFullText
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

    func showNoCoverageEmail() {
        router.showNoCoverageEmail()
    }
}
