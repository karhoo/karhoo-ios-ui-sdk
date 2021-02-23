//
//  MockCancelRideBehaviour.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

@testable import KarhooUISDK

final class MockCancelRideBehaviour: CancelRideBehaviourProtocol {
    weak var delegate: CancelRideDelegate?
    private(set) var cancelPressedCalled = false

    func cancelPressed() {
        cancelPressedCalled = true
    }
}
