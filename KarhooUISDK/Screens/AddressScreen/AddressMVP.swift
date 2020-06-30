//
//  AddressMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

protocol AddressPresenter {
    var addressMode: AddressType { get }

    func viewWillShow()
    func search(text: String?)
    func selected(address: AddressCellViewModel)
    func addressMapViewSelected(location: LocationInfo)
    func getCurrentLocation()
    func close()
    func clearSearch()
}

protocol AddressView: BaseViewController {

    func set(mapPickerIcon: BaseSelectionViewType)
    func set(cells: [AddressCellViewModel])
    func set(title: String?)
    func clearSearchInputField()
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func focusInputField()
    func unfocusInputField()
    func show(emptyDataSetMessage: String)
    func hideEmptyDataSet()
}
