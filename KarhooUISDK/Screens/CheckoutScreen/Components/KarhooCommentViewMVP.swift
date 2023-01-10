//
//  KarhooCommentViewMVP.swift
//
//
//  Created by Bartlomiej Sopala on 05/01/2023.
//

import Foundation
import KarhooSDK

protocol AddCommentViewDelegate: AnyObject {
    func willUpdateComment()
    func didUpdateComment(_ comment: String)
}

protocol AddCommentPresenter {
    func set(comment: String)
}

