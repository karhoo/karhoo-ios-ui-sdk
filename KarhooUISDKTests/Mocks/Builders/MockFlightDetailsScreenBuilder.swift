//
//  MockFlightDetailsScreenFactory.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooUISDK

final class MockFlightDetailsScreenBuilder: FlightDetailsScreenBuilder {

    private(set) var returnViewController: MockViewController?
    private var completionSet: ScreenResultCallback<FlightDetails>?
    func buildFlightDetailsScreen(completion: @escaping ScreenResultCallback<FlightDetails>) -> Screen {
        completionSet = completion

        returnViewController = MockViewController()
        return returnViewController!
    }

    func triggerFlightDetailsScreenResult(_ result: ScreenResult<FlightDetails>) {
        completionSet?(result)
    }
}
