//
//  KarhooTripFeedbackPresenter.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

final class KarhooTripFeedbackPresenter: TripFeedbackPresenter {
    
    var feedbackPayload = [[String: Any]]()
    private let analyticsService: AnalyticsService
    private let tripId: String
    private let resultCallback: ScreenResultCallback<Void>
    private let tripRatingCache: TripRatingCache

    private weak var view: TripFeedbackView?
    
    init(tripId: String,
         analyticsService: AnalyticsService = Karhoo.getAnalyticsService(),
         callback: @escaping ScreenResultCallback<Void>,
         tripRatingCache: TripRatingCache = KarhooTripRatingCache()) {
        self.tripId = tripId
        self.analyticsService = analyticsService
        self.resultCallback = callback
        self.tripRatingCache = tripRatingCache
    }

    func set(view: TripFeedbackView) {
        self.view = view
    }
    
    func getTripId() -> String {
        return tripId
    }
    
    func submitButtonPressed() {
        let payload: [String: Any] = ["tripId": tripId,
                                      "source": "MOBILE",
                                      AnalyticsConstants.EventNames.additional_feedback.rawValue: feedbackPayload,
                                      "timestamp": Date().timeIntervalSince1970]

        analyticsService.send(eventName: .additional_feedback_submitted,
                              payload: payload)

        tripRatingCache.saveTripRated(tripId: tripId)
        
        self.resultCallback(ScreenResult.completed(result: ()))
    }

    func addFeedback(feedback: [String: Any]) {
        feedbackPayload.append(feedback)
    }

    func clearFeedbackData() {
        feedbackPayload = []
    }
}
