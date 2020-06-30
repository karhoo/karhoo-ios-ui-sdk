//
//  RatingViewMVP.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol RatingPresenter {
    
    var ratingOptions: Int { get }
    var ratingMessageTitle: String { get }
    var selectedRating: Int { get }
    var comment: String { get }

    func didRateTrip()
    func set(view: RatingView)
    func getFeedBackDetails() -> [String: Any]
    func setRating(rating: Int)
}

protocol RatingView: class {

    func showConfirmation(_ message: String)
    func hideStars()
    func additionalComment() -> String
}

protocol RatingViewDelegate: class {
    func didRate(_ rating: Int)
}
