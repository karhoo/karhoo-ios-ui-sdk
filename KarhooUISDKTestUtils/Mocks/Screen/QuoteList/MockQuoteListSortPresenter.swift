//
//  MockQuoteListSortPresenter.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 26/10/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK
@testable import KarhooUISDK

public class MockQuoteListSortPresenter: QuoteListSortViewModel {

    public init() {}

    public var sortOptionsToReturn: [KarhooUISDK.QuoteListSortOrder] = KarhooUISDK.QuoteListSortOrder.allCases
    public var sortOptions: [KarhooUISDK.QuoteListSortOrder] {
        sortOptionsToReturn
    }

    public var selectedSortOptionToReturn = KarhooUISDK.QuoteListSortOrder.price
    public var selectedSortOption: KarhooUISDK.QuoteListSortOrder {
        selectedSortOptionToReturn
    }

    public func viewDidLoad() {
    }

    public func viewWillAppear() {
    }

    public var setSortOptionCalled = false
    public func set(sortOption: KarhooUISDK.QuoteListSortOrder) {
        setSortOptionCalled = true
    }

    public var closeWithSaveCalled = false
    public var closeCalled = false
    public func close(save: Bool) {
        closeWithSaveCalled = save
        closeCalled = true
    }
}
