//
//  MockCancelRideBehaviour.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

@testable import KarhooUISDK

final public class MockCancelRideBehaviour: CancelRideBehaviourProtocol {
    weak public var delegate: CancelRideDelegate?
    public var cancelPressedCalled = false

    public func cancelPressed() {
        cancelPressedCalled = true
    }
}
