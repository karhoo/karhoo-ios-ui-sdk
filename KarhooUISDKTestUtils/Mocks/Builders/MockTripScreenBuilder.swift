//
//  MockTripScreenBuilder.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit

@testable import KarhooUISDK

final public class MockTripScreenBuilder: TripScreenBuilder {
    public init() {}

    public var tripSet: TripInfo?
    public var callbackSet: ScreenResultCallback<TripScreenResult>?

    public let returnViewController = UIViewController()

    public func buildTripScreen(trip: TripInfo,
                         callback: @escaping ScreenResultCallback<TripScreenResult>) -> Screen {
        tripSet = trip
        callbackSet = callback
        return returnViewController
    }
}
