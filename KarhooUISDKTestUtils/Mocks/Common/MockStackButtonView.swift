//
//  MockStackButtonView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

@testable import KarhooUISDK

final public class MockStackButtonView: StackButtonView {

    public var singleButtonTextCalled: String?
    public var singleButtonAction: (() -> Void)?

    public func set(buttonText: String, action: @escaping () -> Void) {
        singleButtonTextCalled = buttonText
        singleButtonAction = action
    }

    public var firstButtonTextCalled: String?
    public var firstButtonActionCalled: (() -> Void)?
    public var secondButtonTextCalled: String?
    public var secondButtonActionCalled: (() -> Void)?
    public var firstButtonAction: (() -> Void)?
    public var secondButtonAction: (() -> Void)?

    public func set(firstButtonText: String, firstButtonAction: @escaping () -> Void,
             secondButtonText: String, secondButtonAction: @escaping () -> Void) {
        firstButtonTextCalled = firstButtonText
        firstButtonActionCalled = firstButtonAction
        self.firstButtonAction = firstButtonAction
        secondButtonTextCalled = secondButtonText
        secondButtonActionCalled = secondButtonAction
        self.secondButtonAction = secondButtonAction
    }
}
