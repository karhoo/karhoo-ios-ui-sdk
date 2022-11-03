//
//  MockTripMetaDataActions.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

@testable import KarhooUISDK

final class MockTripMetaDataActions: TripMetaDataActions {

    private(set) var showBaseFareDialogCalled = false
    func showBaseFareDialog() {
        showBaseFareDialogCalled = true
    }
}
