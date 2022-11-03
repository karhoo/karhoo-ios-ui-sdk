//
//  PopupDialogView.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

final public class MockPopupDialogView: PopupDialogView {

    public var theDialogMessageSet: String?
    public func set(dialogMessage: String) {
        theDialogMessageSet = dialogMessage
    }

    public var theFormButtonTitleSet: String?
    public func set(formButtonTitle: String) {
        theFormButtonTitleSet = formButtonTitle
    }

    public var theDialogTitleSet: String?
    public func set(dialogTitle: String) {
        theDialogTitleSet = dialogTitle
    }
}
