//
//  MockFlightDetailsView.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

@testable import KarhooUISDK

final class MockFlightDetailsView: MockBaseViewController, FlightDetailsView {

    private(set) var startKeyboardListenerCalled = false
    func startKeyboardListener() {
        startKeyboardListenerCalled = true
    }

    private(set) var setUpUICalled = false
    func setUpUI() {
        setUpUICalled = true
    }

    private(set) var formButtonEnabledSet: Bool?
    func set(formButtonEnabled: Bool) {
        formButtonEnabledSet = formButtonEnabled
    }

    private(set) var unfocusInputCalled = false
    func unfocusInputFields() {
        unfocusInputCalled = true
    }

    private(set) var flightNumberPlaceHolderSet: String?
    func updateFlightNumberField(placeHolder: String) {
        flightNumberPlaceHolderSet = placeHolder
    }
}
