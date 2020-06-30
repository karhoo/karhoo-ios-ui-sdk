//
//  FeedbackScreenBuilder.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol TripFeedbackScreenBuilder {
    func buildFeedbackScreen(tripId: String,
                             callback: @escaping ScreenResultCallback<Void>) -> Screen
}
