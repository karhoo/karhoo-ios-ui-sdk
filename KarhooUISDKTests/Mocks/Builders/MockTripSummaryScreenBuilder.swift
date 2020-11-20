//
//  MockTripSummaryScreenBuilder.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

@testable import KarhooUISDK

final class MockTripSummaryScreenBuilder: TripSummaryScreenBuilder {

    private(set) var tripSet: TripInfo?
    private(set) var callbackSet: ScreenResultCallback<TripSummaryResult>?

    let returnViewController = UIViewController()

    func buildTripSummaryScreen(trip: TripInfo,
                                   callback: @escaping ScreenResultCallback<TripSummaryResult>) -> Screen {
        tripSet = trip
        callbackSet = callback
        return returnViewController
    }
}
