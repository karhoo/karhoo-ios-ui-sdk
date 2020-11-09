//
//  MockTripScreenBuilder.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

@testable import KarhooUISDK

final class MockTripScreenBuilder: TripScreenBuilder {

    private(set) var tripSet: TripInfo?
    private(set) var callbackSet: ScreenResultCallback<TripScreenResult>?

    let returnViewController = UIViewController()

    func buildTripScreen(trip: TripInfo,
                         callback: @escaping ScreenResultCallback<TripScreenResult>) -> Screen {
        tripSet = trip
        callbackSet = callback
        return returnViewController
    }
}
