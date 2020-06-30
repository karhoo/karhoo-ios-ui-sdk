//
//  MockJourneySummaryScreenBuilder.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

@testable import KarhooUISDK

final class MockJourneySummaryScreenBuilder: JourneySummaryScreenBuilder {

    private(set) var tripSet: TripInfo?
    private(set) var callbackSet: ScreenResultCallback<JourneySummaryResult>?

    let returnViewController = UIViewController()

    func buildJourneySummaryScreen(trip: TripInfo,
                                   callback: @escaping ScreenResultCallback<JourneySummaryResult>) -> Screen {
        tripSet = trip
        callbackSet = callback
        return returnViewController
    }
}
