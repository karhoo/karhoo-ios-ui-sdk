//
//  AddressBarFieldMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol AddressBarFieldView {

    func set(actions: AddressBarFieldActions?)

    func set(text: String?, accessibilityText: String?)

    func ordinaryTextColor()

    func showSpinner()

    func hideSpinner()
}

protocol AddressBarFieldActions: AnyObject {

    func onFieldClear(sender: KarhooAddressBarFieldView)

    func onFieldSelect(sender: KarhooAddressBarFieldView)
    
    func onFieldSet(sender: KarhooAddressBarFieldView)
}
