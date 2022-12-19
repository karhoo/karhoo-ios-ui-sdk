//
//  MockTripSummaryScreenBuilder.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
import Foundation
import KarhooSDK

@testable import KarhooUISDK

final public class MockTripSummaryScreenBuilder: TripSummaryScreenBuilder {

    public var tripSet: TripInfo?
    public var callbackSet: ScreenResultCallback<TripSummaryResult>?

    public let returnViewController = UIViewController()

    public func buildTripSummaryScreen(trip: TripInfo,
                                callback: @escaping ScreenResultCallback<TripSummaryResult>) -> Screen {
        tripSet = trip
        callbackSet = callback
        return returnViewController
    }
}
