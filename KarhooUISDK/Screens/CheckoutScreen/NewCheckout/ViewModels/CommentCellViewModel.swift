//
//  CommentCellViewModel.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 12/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation

class CommentCellViewModel: DetailsCellViewModel {
    
    private var comment: String = ""

    init(onTap: @escaping () -> Void = {}) {
        super.init(
            title: UITexts.Booking.commentsTitle,
            subtitle: UITexts.Booking.commentsSubtitle,
            iconName: "kh_uisdk_comments",
            onTap: onTap
        )
    }
    
    func getComment() -> String {
        comment
    }
    
    private func getSubtitle() -> String {
        comment.isNotEmpty ? comment : UITexts.Booking.commentsSubtitle
    }
    
    func setComment(_ comment: String) {
        self.comment = comment
        subtitle = getSubtitle()
    }
}
