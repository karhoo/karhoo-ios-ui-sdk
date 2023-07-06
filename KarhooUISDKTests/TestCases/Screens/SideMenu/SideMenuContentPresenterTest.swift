//
//  SideMenuContentPresenterTest.swift
//  KarhooUISDKTests
//
//  Created by Matei Dediu on 05.05.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import XCTest
import KarhooUISDKTestUtils
@testable import KarhooUISDK

final class SideMenuContentPresenterTest: KarhooTestCase {

    private var testObject: MenuContentScreenPresenter!
    private var mockSideMenuHandler: MockSideMenuHandler!
    private var mockContentView: MockContentView!
    override func setUp() {
        super.setUp()
       
        mockSideMenuHandler = MockSideMenuHandler()
        mockContentView = MockContentView()
        testObject = MenuContentScreenPresenter(routing: mockSideMenuHandler, mailConstructor: KarhooFeedbackEmailComposer())
        testObject.set(view: mockContentView)
    }

    /**
     * When pressing on bookings/rides
     * Then the side menu handler callback should receive the action
      */
    func testBookingsPressed() {
        testObject.bookingsPressed()
        
        XCTAssertTrue(mockSideMenuHandler.pressedOnBookings)
    }
    
    /**
      * When pressing on about
      * Then the side menu handler callback should receive the action
      */
    func testAboutPressed() {
        testObject.aboutPressed()
        
        XCTAssertTrue(mockSideMenuHandler.pressedOnAbout)
    }
    
    /**
     * When pressing on profile
     * Then the side menu handler callback should receive the action
      */
    func testProfilePressed() {
        testObject.profilePressed()
        
        XCTAssertTrue(mockSideMenuHandler.pressedOnProfile)
    }
    
    /**
     * When pressing on help
     * Then the side menu handler callback should receive the action
      */
    func testHelpPressed() {
        testObject.helpPressed()
        
        XCTAssertTrue(mockSideMenuHandler.pressedOnHelp)
    }
    
    /**
     * When the authentication method is guest
     * Then the presenter will call the side menu view's showGuestMenu method
      */
    func testGuestMenuIfAuthenticationMethodIsGuest() {
        KarhooTestConfiguration.authenticationMethod = .guest(settings: KarhooTestConfiguration.guestSettings)
        
        testObject.checkGuestAuthentication()
        
        XCTAssertTrue(mockContentView.calledShowGuestMenu)
    }
    
}
