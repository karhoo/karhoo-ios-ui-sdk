//
//  CommentCellViewController.swift
//
//
//  Created by Bartlomiej Sopala on 09/01/2023.
//

import Foundation
import SwiftUI
import KarhooSDK

class CommentCellViewController: DetailsCellViewController, AddCommentPresenter {
    
    private let analyticsService: AnalyticsService
    var comment: String?
    weak var delegate: AddCommentViewDelegate?
    
    init(
        analyticsService: AnalyticsService = Karhoo.getAnalyticsService(),
        comment: String?,
        delegate: AddCommentViewDelegate
    ) {
        self.analyticsService = analyticsService
        self.comment = comment
        self.delegate = delegate
        super.init(
            rootView: DetailsCellView(model: Self.getModel(comment)),
            onTap: delegate.willUpdateComment
        )
        rootView.delegate = self
        self.view.accessibilityIdentifier = "passenger_details_cell_view"
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(comment: String) {
        self.comment = comment
        let model = Self.getModel(comment)
        delegate?.didUpdateComment(comment)
        rootView.model.update(title: model.title, subtitle: model.subtitle)
    }
    
    private static func getModel(_ comment: String?) -> DetailsCellViewModel {
        let subtitle = comment ?? UITexts.Booking.commentsSubtitle
        return DetailsCellViewModel(
            title: UITexts.Booking.commentsTitle,
            subtitle: subtitle,
            iconName: "kh_uisdk_comments"
        )
    }
}

