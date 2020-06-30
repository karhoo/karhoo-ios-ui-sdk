//
//  AddressSearchBarMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

protocol AddressSearchBarPresenter {
    func searchTextChanged(text: String?)
}

protocol AddressSearchBar: AnyObject {
    func set(searchPlaceholder: String?)
    func set(maxInputCharacters: Int)
    func clearSearchInputField()
    func focusInputField()
    func unfocusInputField()
    func resignFirstResponder() -> Bool
    func hideClearButton(hide: Bool)
    func set(ringColor: UIColor)
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

protocol AddressSearchBarActions {
    func search(text: String?)
    func clearSearch()
}
