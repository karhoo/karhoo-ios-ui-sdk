//
//  MockAddressView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
@testable import KarhooUISDK

final public class MockAddressView: MockBaseViewController, AddressView {

    public var setCellCalled = false
    public var addressCellsToShow: [AddressCellViewModel]?
    public func set(cells: [AddressCellViewModel]) {
        setCellCalled = true
        addressCellsToShow = cells
    }

    public var setTitleCalled = false
    public var titleString: String?
    public func set(title: String?) {
        setTitleCalled = true
        titleString = title
    }

    public var mapPickerIconSet: BaseSelectionViewType?
    public func set(mapPickerIcon: BaseSelectionViewType) {
        mapPickerIconSet = mapPickerIcon
    }

    public var showLoadingIndicatorCalled = false
    public func showLoadingIndicator() {
        showLoadingIndicatorCalled = true
    }

    public var hideLoadingIndicatorCalled = false
    public func hideLoadingIndicator() {
        hideLoadingIndicatorCalled = true
    }

    public var hideClearButtonCalled = false
    public func hideClearButton() {
        hideClearButtonCalled = true
    }

    public var showClearButtonCalled = false
    public func showClearButton() {
        showClearButtonCalled = true
    }

    public var focusInputFieldCalled = false
    public func focusInputField() {
        focusInputFieldCalled = true
    }

    public var unfocusInputFieldCalled = false
    public func unfocusInputField() {
        unfocusInputFieldCalled = true
    }

    public var showLoadingScreenCalled = false
    public func showLoadingScreen() {
        showLoadingScreenCalled = true
    }

    public var hideLoadingScreenCalled = false
    public func hideLoadingScreen() {
        hideLoadingScreenCalled = true
    }

    public var clearSearchFieldCalled = false
    public func clearSearchInputField() {
        clearSearchFieldCalled = true
    }

    public var emptyDataSetMessageSet: String?
    public func show(emptyDataSetMessage: String) {
        emptyDataSetMessageSet = emptyDataSetMessage
    }

    public var hideEmptyDataSetCalled = false
    public func hideEmptyDataSet() {
        hideEmptyDataSetCalled = true
    }
    
    public var hasCalledTheBuildMapViewMethod = false
    public func buildAddressMapView() {
        hasCalledTheBuildMapViewMethod = true
    }
    
    public var hasCalledDisableLocationOptionsMethod = false
    public func disableLocationOptions() {
        hasCalledDisableLocationOptionsMethod = true
    }
}
