//
//  KarhooLoyaltyPresenterSpec.swift
//  KarhooUISDKTests
//
//  Created by Diana Petrea on 18.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import XCTest
@testable import KarhooUISDK

class KarhooLoyaltyPresenterSpec: XCTestCase {
    
    private var testObject: KarhooLoyaltyPresenter!
    private var mockView: MockLoyaltyView!
    private var mockDelegate: MockLoyaltyViewDelegate!

    override func setUp() {
        super.setUp()
        
        mockView = MockLoyaltyView()
        testObject = KarhooLoyaltyPresenter(view: mockView)
        mockDelegate = MockLoyaltyViewDelegate()
        testObject.delegate = mockDelegate
    }
    
    /**
     *  When:   The the loyalty mode is updated to .earn mode
     *  Then:   The view is updated
     *  And: The delegate is notified of the change
     */
    func testUpdateLoyaltyModeToEarn() {
        testObject.updateLoyaltyMode(with: .earn)
        
        XCTAssertTrue(testObject.getCurrentMode() == .earn)
        XCTAssertTrue(mockView.didCallSetLoyaltyMode)
        XCTAssertTrue(mockDelegate.didCallToggleLoyaltyMode)
    }
    
    /**
     *  When:   The the loyalty mode is updated to .burn mode
     *  Then:   The view is updated
     *  And: The delegate is notified of the change
     */
    func testUpdateLoyaltyModeToBurn() {
        testObject.updateLoyaltyMode(with: .burn)
        
        XCTAssertTrue(testObject.getCurrentMode() == .burn)
        XCTAssertTrue(mockView.didCallSetLoyaltyMode)
        XCTAssertTrue(mockDelegate.didCallToggleLoyaltyMode)
    }
}
