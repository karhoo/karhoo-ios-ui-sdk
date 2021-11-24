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
    private var mockViewModel: LoyaltyViewModel!

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
    func testUpdateLoyaltyModeToEarnWithEarnOnBurnOn() {
        let randomFare = TestUtil.getRandomTripFare()
        mockViewModel = LoyaltyViewModel(loyaltyId: TestUtil.getRandomString(), currency: randomFare.currency, tripAmount: Double(randomFare.total), canEarn: true, canBurn: true)
        testObject.set(viewModel: mockViewModel)
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
        mockViewModel = LoyaltyViewModel(loyaltyId: TestUtil.getRandomString(), currency: randomFare.currency, tripAmount: Double(randomFare.total), canEarn: false, canBurn: true)
        testObject.set(viewModel: mockViewModel)
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
        mockViewModel = LoyaltyViewModel(loyaltyId: TestUtil.getRandomString(), currency: randomFare.currency, tripAmount: Double(randomFare.total), canEarn: true, canBurn: false)
        testObject.set(viewModel: mockViewModel)
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
        mockViewModel = LoyaltyViewModel(loyaltyId: TestUtil.getRandomString(), currency: randomFare.currency, tripAmount: Double(randomFare.total), canEarn: false, canBurn: false)
        testObject.set(viewModel: mockViewModel)
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
        mockViewModel = LoyaltyViewModel(loyaltyId: TestUtil.getRandomString(), currency: randomFare.currency, tripAmount: Double(randomFare.total), canEarn: true, canBurn: true)
        testObject.set(viewModel: mockViewModel)
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
        mockViewModel = LoyaltyViewModel(loyaltyId: TestUtil.getRandomString(), currency: randomFare.currency, tripAmount: Double(randomFare.total), canEarn: false, canBurn: true)
        testObject.set(viewModel: mockViewModel)
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
        mockViewModel = LoyaltyViewModel(loyaltyId: TestUtil.getRandomString(), currency: randomFare.currency, tripAmount: Double(randomFare.total), canEarn: true, canBurn: false)
        testObject.set(viewModel: mockViewModel)
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
        mockViewModel = LoyaltyViewModel(loyaltyId: TestUtil.getRandomString(), currency: randomFare.currency, tripAmount: Double(randomFare.total), canEarn: false, canBurn: false)
        testObject.set(viewModel: mockViewModel)
        testObject.updateLoyaltyMode(with: .burn)
        
        XCTAssertFalse(testObject.getCurrentMode() == .burn)
        XCTAssertFalse(mockView.didCallSetLoyaltyMode)
        XCTAssertFalse(mockDelegate.didCallToggleLoyaltyMode)
    }
}
