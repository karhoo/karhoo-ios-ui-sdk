//
//  MockPopupDialogScreenBuilder.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import UIKit
@testable import KarhooUISDK

final public class MockPopupDialogScreenBuilder: PopupDialogScreenBuilder {
    public init() {}

    private var callbackSet: ScreenResultCallback<Void>?
    public let returnScreen = UIViewController()
    public var buildPopupScreenCalled = false
    public func buildPopupDialogScreen(callback: @escaping ScreenResultCallback<Void>) -> Screen {
        callbackSet = callback
        buildPopupScreenCalled = true
        return returnScreen
    }

    public func triggerScreenResult(_ result: ScreenResult<Void>) {
        callbackSet?(result)
    }
}
