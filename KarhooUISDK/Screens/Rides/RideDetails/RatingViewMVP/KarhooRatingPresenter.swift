//
//  RatingViewPresenter.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooRatingPresenter: RatingPresenter {

    var ratingOptions: Int = 5
    var ratingType: RatingType = .generic
    var selectedRating: Int = 0
    var comment: String = ""
    private weak var view: RatingView?

    var ratingMessageTitle: String {
        return ratingType.title
    }
        
    init(ratingOptions: Int = 5,
         ratingType: RatingType = .generic) {
        self.ratingOptions = ratingOptions
        self.ratingType = ratingType
    }

    func set(view: RatingView) {
        self.view = view
    }

    func didRateTrip() {
        view?.showConfirmation(ratingType.ratingFeedbackTitle)
    }
    
    func getFeedBackDetails() -> [String: Any] {
        return ["id": ratingType.eventName?.rawValue ?? "",
                "rating": selectedRating,
                "comments": view?.additionalComment() ?? ""]
    }
    
    func setRating(rating: Int) {
        selectedRating = rating
    }
}
