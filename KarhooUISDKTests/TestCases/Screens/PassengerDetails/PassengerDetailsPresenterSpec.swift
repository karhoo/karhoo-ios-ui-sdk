//
//  PassengerDetailsPresenterSpec.swift
//  KarhooUISDKTests
//
//  Created by Diana Petrea on 08.09.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import XCTest
import KarhooSDK
@testable import KarhooUISDK

class PassengerDetailsPresenterSpec: KarhooTestCase {
    
    private var testObject: PassengerDetailsPresenter!
    private var mockView: MockPassengerDetailsViewController!
    private var mockDetails: PassengerDetails!
    private var mockDelegate: MockPassengerDetailsDelegate!
    
    override func setUp() {
        super.setUp()
        
        mockDelegate = MockPassengerDetailsDelegate()
        mockDetails = TestUtil.getRandomPassengerDetails()
        testObject = PassengerDetailsPresenter()
        mockView = MockPassengerDetailsViewController()
        mockView.details = mockDetails
        testObject.delegate = mockDelegate
        mockView.delegate = mockDelegate
    }
    
    /**
      * When: the user finishes inputting and clicks NEXT
      * Then: the details passed are returned in the callback
      */
    func testDoneClicked() {
        testObject.doneClicked(newDetails: mockDetails, country: KarhooCountryParser.defaultCountry)
        XCTAssert(mockDelegate.didInputPassengerDetailsCalled)
        XCTAssert(mockDelegate.details?.details == mockDetails)
    }
    
    /**
      * When: the user finishes inputting and clicks NEXT
      * Then: the details in the callback are nil
      */
    func testBackClicked() {
        testObject.backClicked()
        XCTAssert(mockDelegate.didCancelInputCalled)
        XCTAssert(mockDelegate.details == nil)
    }
    
    /**
      * When: the user begins editing the text field
      * Then: didBecomeActive() in called
      */
    func testDidBecomeActiveCalled() {
        mockView.textField.setActive()
        XCTAssertTrue(mockView.didBecomeActiveCalled)
    }
    
    /**
      * When: the user ends editing the text field
      * Then: didBecomeInactive is called
      */
    func testDidBecomeInactiveCalled() {
        mockView.textField.setInactive()
        XCTAssertTrue(mockView.didBecomeInactiveCalled)
    }
    
    /**
      * When: we set the text in the text field
      * Then: didChangeCharacterInSet is not called
      * didChangeCharacterInSet should be called only when the input field is edited manually by the user
      */
    func testDidChangeCharacterInSetCalled() {
        mockView.textField.set(text: TestUtil.getRandomString())
        XCTAssertFalse(mockView.didChangeCharacterInSetCalled)
    }
}
