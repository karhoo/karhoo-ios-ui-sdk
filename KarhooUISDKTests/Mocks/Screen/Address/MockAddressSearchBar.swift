//
//  MockAddressSearchBar.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooUISDK

class MockAddressSearchBar: AddressSearchBar {

    var ringColorSet: UIColor?
    func set(ringColor: UIColor) {
        ringColorSet = ringColor
    }

    var setHintCalled = false
    var searchPlaceHolder: String?
    func set(searchPlaceholder: String?) {
        setHintCalled = true
        searchPlaceHolder = searchPlaceholder
    }

    var clearSearchFieldCalled = false
    func clearSearchInputField() {
        clearSearchFieldCalled = true
    }

    var focusInputFieldCalled = false
    func focusInputField() {
        focusInputFieldCalled = true
    }

    var unfocusInputFieldCalled = false
    func unfocusInputField() {
        unfocusInputFieldCalled = true
    }

    var resignFirstResponderCalled = false
    func resignFirstResponder() -> Bool {
        resignFirstResponderCalled = true
        return true
    }
    
    var showLoadingIndicatorCalled = false
    func showLoadingIndicator() {
        showLoadingIndicatorCalled = true
    }

    var hideLoadingIndicatorCalled = false
    func hideLoadingIndicator() {
        hideLoadingIndicatorCalled = true
    }
    
    var maxCharSet: Int = -1
    func set(maxInputCharacters: Int) {
        maxCharSet = maxInputCharacters
    }
    
    var clearButtonHidden: Bool = false
    func hideClearButton(hide: Bool) {
        clearButtonHidden = hide
    }
}
