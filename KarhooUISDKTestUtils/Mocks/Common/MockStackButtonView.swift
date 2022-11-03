//
//  MockStackButtonView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

@testable import KarhooUISDK

final class MockStackButtonView: StackButtonView {

    var singleButtonTextCalled: String?
    var singleButtonAction: (() -> Void)?

    func set(buttonText: String, action: @escaping () -> Void) {
        singleButtonTextCalled = buttonText
        singleButtonAction = action
    }

    var firstButtonTextCalled: String?
    var firstButtonActionCalled: (() -> Void)?
    var secondButtonTextCalled: String?
    var secondButtonActionCalled: (() -> Void)?
    var firstButtonAction: (() -> Void)?
    var secondButtonAction: (() -> Void)?

    func set(firstButtonText: String, firstButtonAction: @escaping () -> Void,
             secondButtonText: String, secondButtonAction: @escaping () -> Void) {
        firstButtonTextCalled = firstButtonText
        firstButtonActionCalled = firstButtonAction
        self.firstButtonAction = firstButtonAction
        secondButtonTextCalled = secondButtonText
        secondButtonActionCalled = secondButtonAction
        self.secondButtonAction = secondButtonAction
    }
}
