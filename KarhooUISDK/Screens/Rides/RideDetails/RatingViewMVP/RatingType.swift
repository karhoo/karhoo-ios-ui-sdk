//
//  RatingType.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

enum RatingType {
    case
    generic,
    quote,
    pre_pob,
    pob,
    app,
    clean
    
    var title: String {
        switch self {
        case .generic:
            return UITexts.TripRating.ratingTitleMessage
        case .quote:
            return UITexts.TripRating.quoteFeedbackTitle
        case .pre_pob:
            return UITexts.TripRating.prePobFeedbackTitle
        case .pob:
            return UITexts.TripRating.pobFeedbackTitle
        case .app:
            return UITexts.TripRating.appFeedbackTitle
        default:
            return ""
        }
    }
    
    var ratingFeedbackTitle: String {
        switch self {
        case .generic:
            return UITexts.TripRating.thankYouConfirmation
        case .quote:
            return UITexts.TripRating.quoteFeedbackTitle
        case .pre_pob:
            return UITexts.TripRating.prePobFeedbackTitle
        case .pob:
            return UITexts.TripRating.pobFeedbackTitle
        case .app:
            return UITexts.TripRating.appFeedbackTitle
        default:
            return ""
        }
    }

    var eventName: AnalyticsConstants.EventNames? {
        switch self {
        case .generic:
            return AnalyticsConstants.EventNames.tripRatingSubmitted
        case .quote:
            return AnalyticsConstants.EventNames.quoteRating
        case .pre_pob:
            return AnalyticsConstants.EventNames.prePobRating
        case .pob:
            return AnalyticsConstants.EventNames.pobExperienceRating
        case .app:
            return AnalyticsConstants.EventNames.appExperienceRating
        default:
            return nil
        }
    }
}
