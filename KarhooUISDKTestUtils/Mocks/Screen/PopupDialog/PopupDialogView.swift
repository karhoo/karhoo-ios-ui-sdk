//
//  PopupDialogView.swift
//  KarhooUISDKTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

final class MockPopupDialogView: PopupDialogView {

    private(set) var theDialogMessageSet: String?
    func set(dialogMessage: String) {
        theDialogMessageSet = dialogMessage
    }

    private(set) var theFormButtonTitleSet: String?
    func set(formButtonTitle: String) {
        theFormButtonTitleSet = formButtonTitle
    }

    private(set) var theDialogTitleSet: String?
    func set(dialogTitle: String) {
        theDialogTitleSet = dialogTitle
    }
}
