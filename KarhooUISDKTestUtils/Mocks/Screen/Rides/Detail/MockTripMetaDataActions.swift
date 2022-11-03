//
//  MockTripMetaDataActions.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

@testable import KarhooUISDK

final public class MockTripMetaDataActions: TripMetaDataActions {
    public init() {}

    public var showBaseFareDialogCalled = false
    public func showBaseFareDialog() {
        showBaseFareDialogCalled = true
    }
}
