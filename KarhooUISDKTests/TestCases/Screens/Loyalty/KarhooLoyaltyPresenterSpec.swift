//
//  KarhooLoyaltyPresenterSpec.swift
//  KarhooUISDKTests
//
//  Created by Diana Petrea on 18.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import XCTest
import KarhooSDK
@testable import KarhooUISDKTestUtils
@testable import KarhooUISDK

class KarhooLoyaltyPresenterSpec: KarhooTestCase {
    
    private var testObject: KarhooLoyaltyPresenter!
    private var mockView: MockLoyaltyView!
    private var mockDelegate: MockLoyaltyViewDelegate!
    private var mockDataModel: LoyaltyViewDataModel!

    override func setUp() {
        super.setUp()
        
        mockView = MockLoyaltyView()
        testObject = KarhooLoyaltyPresenter()
        mockDelegate = MockLoyaltyViewDelegate()
        testObject.delegate = mockDelegate
        testObject.presenterDelegate = mockView
    }
    
    /**
     *  When:   The the loyalty mode is updated to .earn mode
     *  Then:   The view is updated
     *  And: The delegate is notified of the change
     */
    func testUpdateLoyaltyModeToEarnWithEarnOnBurnOn() {
        let randomFare = TestUtil.getRandomTripFare()
        mockDataModel = LoyaltyViewDataModel(loyaltyId: TestUtil.getRandomString(), currency: randomFare.currency, tripAmount: Double(randomFare.total))
        testObject.set(dataModel: mockDataModel)
        testObject.set(status: LoyaltyStatus(balance: 0, canBurn: true, canEarn: true))
        testObject.updateLoyaltyMode(with: .earn)
        
        XCTAssertTrue(testObject.getCurrentMode() == .earn)
        XCTAssertTrue(mockView.didCallSetLoyaltyMode)
        XCTAssertTrue(mockDelegate.didCallToggleLoyaltyMode)
    }
    
    /**
     *  When:   The the loyalty mode is updated to .earn mode
     *  Then:   The view is not updated
     *  And: The delegate is notified of the change
     */
    func testUpdateLoyaltyModeToEarnWithEarnOffBurnOn() {
        let randomFare = TestUtil.getRandomTripFare()
        mockDataModel = LoyaltyViewDataModel(loyaltyId: TestUtil.getRandomString(), currency: randomFare.currency, tripAmount: Double(randomFare.total))
        testObject.set(dataModel: mockDataModel)
        testObject.set(status: LoyaltyStatus(balance: 0, canBurn: true, canEarn: false))
        testObject.updateLoyaltyMode(with: .earn)
        
        XCTAssertFalse(testObject.getCurrentMode() == .earn)
        XCTAssertTrue(mockView.didCallSetLoyaltyMode)
        XCTAssertTrue(mockDelegate.didCallToggleLoyaltyMode)
    }
    
    /**
     *  When:   The the loyalty mode is updated to .earn mode
     *  Then:   The view is updated
     *  And: The delegate is notified of the change
     */
    func testUpdateLoyaltyModeToEarnWithEarnOnBurnOff() {
        let randomFare = TestUtil.getRandomTripFare()
        mockDataModel = LoyaltyViewDataModel(loyaltyId: TestUtil.getRandomString(), currency: randomFare.currency, tripAmount: Double(randomFare.total))
        testObject.set(dataModel: mockDataModel)
        testObject.set(status: LoyaltyStatus(balance: 0, canBurn: false, canEarn: true))
        testObject.updateLoyaltyMode(with: .earn)
        
        XCTAssertTrue(testObject.getCurrentMode() == .earn)
        XCTAssertTrue(mockView.didCallSetLoyaltyMode)
        XCTAssertTrue(mockDelegate.didCallToggleLoyaltyMode)
    }
    
    /**
     *  When:   The the loyalty mode is updated to .earn mode
     *  Then:   The view is not updated
     *  And: The delegate is notified of the change
     */
    func testUpdateLoyaltyModeToEarnWithEarnOffBurnOff() {
        let randomFare = TestUtil.getRandomTripFare()
        mockDataModel = LoyaltyViewDataModel(loyaltyId: TestUtil.getRandomString(), currency: randomFare.currency, tripAmount: Double(randomFare.total))
        testObject.set(dataModel: mockDataModel)
        testObject.set(status: LoyaltyStatus(balance: 0, canBurn: false, canEarn: false))
        testObject.updateLoyaltyMode(with: .earn)
        
        XCTAssertFalse(testObject.getCurrentMode() == .earn)
        XCTAssertTrue(mockView.didCallSetLoyaltyMode)
        XCTAssertTrue(mockDelegate.didCallToggleLoyaltyMode)
    }
    
    /**
     *  When:   The the loyalty mode is updated to .burn mode
     *  Then:   The view is updated
     *  And: The delegate is notified of the change
     */
    func testUpdateLoyaltyModeToBurnWithEarnOnBurnOn() {
        let randomFare = TestUtil.getRandomTripFare()
        mockDataModel = LoyaltyViewDataModel(loyaltyId: TestUtil.getRandomString(), currency: randomFare.currency, tripAmount: Double(randomFare.total))
        testObject.set(dataModel: mockDataModel)
        testObject.set(status: LoyaltyStatus(balance: 0, canBurn: true, canEarn: true))
        testObject.updateLoyaltyMode(with: .burn)
        
        XCTAssertTrue(testObject.getCurrentMode() == .burn)
        XCTAssertTrue(mockView.didCallSetLoyaltyMode)
        XCTAssertTrue(mockDelegate.didCallToggleLoyaltyMode)
    }
    
    /**
     *  When:   The the loyalty mode is updated to .burn mode
     *  Then:   The view is updated
     *  And: The delegate is notified of the change
     */
    func testUpdateLoyaltyModeToBurnWithEarnOffBurnOn() {
        let randomFare = TestUtil.getRandomTripFare()
        mockDataModel = LoyaltyViewDataModel(loyaltyId: TestUtil.getRandomString(), currency: randomFare.currency, tripAmount: Double(randomFare.total))
        testObject.set(dataModel: mockDataModel)
        testObject.set(status: LoyaltyStatus(balance: 0, canBurn: true, canEarn: false))
        testObject.updateLoyaltyMode(with: .burn)
        
        XCTAssertTrue(testObject.getCurrentMode() == .burn)
        XCTAssertTrue(mockView.didCallSetLoyaltyMode)
        XCTAssertTrue(mockDelegate.didCallToggleLoyaltyMode)
    }
    
    /**
     *  When:   The the loyalty mode is updated to .burn mode
     *  Then:   The view is not updated
     *  And: The delegate is not notified of the change
     */
    func testUpdateLoyaltyModeToBurnWithEarnOnBurnOff() {
        let randomFare = TestUtil.getRandomTripFare()
        mockDataModel = LoyaltyViewDataModel(loyaltyId: TestUtil.getRandomString(), currency: randomFare.currency, tripAmount: Double(randomFare.total))
        testObject.set(dataModel: mockDataModel)
        testObject.set(status: LoyaltyStatus(balance: 0, canBurn: false, canEarn: true))
        testObject.updateLoyaltyMode(with: .burn)
        
        XCTAssertFalse(testObject.getCurrentMode() == .burn)
        XCTAssertFalse(mockView.didCallSetLoyaltyMode)
        XCTAssertFalse(mockDelegate.didCallToggleLoyaltyMode)
    }
    
    /**
     *  When:   The the loyalty mode is updated to .burn mode
     *  Then:   The view is not updated
     *  And: The delegate is not notified of the change
     */
    func testUpdateLoyaltyModeToBurnWithEarnOffBurnOff() {
        let randomFare = TestUtil.getRandomTripFare()
        mockDataModel = LoyaltyViewDataModel(loyaltyId: TestUtil.getRandomString(), currency: randomFare.currency, tripAmount: Double(randomFare.total))
        testObject.set(dataModel: mockDataModel)
        testObject.set(status: LoyaltyStatus(balance: 0, canBurn: false, canEarn: false))
        testObject.updateLoyaltyMode(with: .burn)
        
        XCTAssertFalse(testObject.getCurrentMode() == .burn)
        XCTAssertFalse(mockView.didCallSetLoyaltyMode)
        XCTAssertFalse(mockDelegate.didCallToggleLoyaltyMode)
    }
}
