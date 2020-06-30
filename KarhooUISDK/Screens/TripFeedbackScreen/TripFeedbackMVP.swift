//
//  TripFeedbackMVP.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol TripFeedbackPresenter {
    func submitButtonPressed()
    func getTripId() -> String
    func clearFeedbackData()
    func addFeedback(feedback: [String: Any])
}

protocol TripFeedbackView: BaseViewController {}
