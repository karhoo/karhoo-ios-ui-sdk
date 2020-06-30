//
//  KarhooAddressSearchBarPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooAddressSearchBarPresenter: AddressSearchBarPresenter {

    let addressSearchBar: AddressSearchBar
    let addressMode: AddressType?

    init(addressSearchBar: AddressSearchBar,
         addressMode: AddressType?) {
        self.addressSearchBar = addressSearchBar
        self.addressMode = addressMode
        self.configureFor(mode: addressMode)
    }

    func searchTextChanged(text: String?) {
        shouldShowClearButtonFor(text: text)
    }

    private func configureFor(mode: AddressType?) {
        if mode == .pickup {
            addressSearchBar.set(searchPlaceholder: UITexts.AddressBar.enterPickup)
            addressSearchBar.set(ringColor: KarhooUI.colors.secondary)
        } else {
            addressSearchBar.set(searchPlaceholder: UITexts.AddressBar.enterDestination)
            addressSearchBar.set(ringColor: KarhooUI.colors.primary)
        }
        
        addressSearchBar.set(maxInputCharacters: 38)
    }

    private func shouldShowClearButtonFor(text: String?) {
        guard let noText = text?.isEmpty else { return }
        addressSearchBar.hideClearButton(hide: noText)
    }
}
