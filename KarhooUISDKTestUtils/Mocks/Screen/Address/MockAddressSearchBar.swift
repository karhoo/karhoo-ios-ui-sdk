//
//  MockAddressSearchBar.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import UIKit

@testable import KarhooUISDK

public class MockAddressSearchBar: AddressSearchBar {
    public init() {}

    public var ringColorSet: UIColor?
    public func set(ringColor: UIColor) {
        ringColorSet = ringColor
    }

    public var setHintCalled = false
    public var searchPlaceHolder: String?
    public func set(searchPlaceholder: String?) {
        setHintCalled = true
        searchPlaceHolder = searchPlaceholder
    }

    public var clearSearchFieldCalled = false
    public func clearSearchInputField() {
        clearSearchFieldCalled = true
    }

    public var focusInputFieldCalled = false
    public func focusInputField() {
        focusInputFieldCalled = true
    }

    public var unfocusInputFieldCalled = false
    public func unfocusInputField() {
        unfocusInputFieldCalled = true
    }

    public var resignFirstResponderCalled = false
    public func resignFirstResponder() -> Bool {
        resignFirstResponderCalled = true
        return true
    }
    
    public var showLoadingIndicatorCalled = false
    public func showLoadingIndicator() {
        showLoadingIndicatorCalled = true
    }

    public var hideLoadingIndicatorCalled = false
    public func hideLoadingIndicator() {
        hideLoadingIndicatorCalled = true
    }
    
    public var maxCharSet: Int = -1
    public func set(maxInputCharacters: Int) {
        maxCharSet = maxInputCharacters
    }
    
    public var clearButtonHidden: Bool = false
    public func hideClearButton(hide: Bool) {
        clearButtonHidden = hide
    }
}
