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

//    func mockCancelRideBehaviour() {
//        delegate?.showLoadingOverlay()
//        delegate?.sendCancelRideNetworkRequest(callback: { [weak self] _ in
//            self?.delegate?.hideLoadingOverlay()
//        })
//    }
}
