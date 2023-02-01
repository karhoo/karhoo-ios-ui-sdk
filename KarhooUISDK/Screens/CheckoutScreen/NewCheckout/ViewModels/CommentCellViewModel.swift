//
//  CommentCellViewModel.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 12/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import Combine

class CommentCellViewModel: DetailsCellViewModel {

    private(set)var commentSubject = CurrentValueSubject<String, Never>("")

    init(onTap: @escaping () -> Void = {}) {
        super.init(
            title: UITexts.Booking.commentsTitle,
            subtitle: UITexts.Booking.commentsSubtitle,
            iconName: "kh_uisdk_comments",
            onTap: onTap
        )
    }
    
    func getComment() -> String {
        commentSubject.value
    }
    
    private func getSubtitle() -> String {
        commentSubject.value.isNotEmpty ? commentSubject.value : UITexts.Booking.commentsSubtitle
    }
    
    func setComment(_ comment: String) {
        self.commentSubject.send(comment)
        subtitle = getSubtitle()
    }
}
