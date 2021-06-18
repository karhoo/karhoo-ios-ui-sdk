//
//  MockAddressScreen.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
@testable import KarhooUISDK

final class MockAddressView: MockBaseViewController, AddressView {

    private(set) var setCellCalled = false
    private(set) var addressCellsToShow: [AddressCellViewModel]?
    func set(cells: [AddressCellViewModel]) {
        setCellCalled = true
        addressCellsToShow = cells
    }

    private(set) var setTitleCalled = false
    var titleString: String?
    func set(title: String?) {
        setTitleCalled = true
        titleString = title
    }

    private(set) var mapPickerIconSet: BaseSelectionViewType?
    func set(mapPickerIcon: BaseSelectionViewType) {
        mapPickerIconSet = mapPickerIcon
    }

    private(set) var showLoadingIndicatorCalled = false
    func showLoadingIndicator() {
        showLoadingIndicatorCalled = true
    }

    private(set) var hideLoadingIndicatorCalled = false
    func hideLoadingIndicator() {
        hideLoadingIndicatorCalled = true
    }

    private(set) var hideClearButtonCalled = false
    func hideClearButton() {
        hideClearButtonCalled = true
    }

    private(set) var showClearButtonCalled = false
    func showClearButton() {
        showClearButtonCalled = true
    }

    private(set) var focusInputFieldCalled = false
    func focusInputField() {
        focusInputFieldCalled = true
    }

    private(set) var unfocusInputFieldCalled = false
    func unfocusInputField() {
        unfocusInputFieldCalled = true
    }

    private(set) var showLoadingScreenCalled = false
    func showLoadingScreen() {
        showLoadingScreenCalled = true
    }

    private(set) var hideLoadingScreenCalled = false
    func hideLoadingScreen() {
        hideLoadingScreenCalled = true
    }

    private(set) var clearSearchFieldCalled = false
    func clearSearchInputField() {
        clearSearchFieldCalled = true
    }

    private(set) var emptyDataSetMessageSet: String?
    func show(emptyDataSetMessage: String) {
        emptyDataSetMessageSet = emptyDataSetMessage
    }

    private(set) var hideEmptyDataSetCalled = false
    func hideEmptyDataSet() {
        hideEmptyDataSetCalled = true
    }
    
    private(set) var hasCalledTheBuildMapViewMethod = false
    func buildAddressMapView() {
        hasCalledTheBuildMapViewMethod = true
    }
    
    private(set) var hasCalledDisableLocationOptionsMethod = false
    func disableLocationOptions() {
        hasCalledDisableLocationOptionsMethod = true
    }
}
