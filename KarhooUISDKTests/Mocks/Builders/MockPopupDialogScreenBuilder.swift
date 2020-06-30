//
//  MockPopupDialogScreenBuilder.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

final class MockPopupDialogScreenBuilder: PopupDialogScreenBuilder {

    private var callbackSet: ScreenResultCallback<Void>?
    let returnScreen = UIViewController()
    private(set) var buildPopupScreenCalled = false
    func buildPopupDialogScreen(callback: @escaping ScreenResultCallback<Void>) -> Screen {
        callbackSet = callback
        buildPopupScreenCalled = true
        return returnScreen
    }

    func triggerScreenResult(_ result: ScreenResult<Void>) {
        callbackSet?(result)
    }
}
