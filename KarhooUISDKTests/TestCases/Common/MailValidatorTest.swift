//
//  MailValidatorTest.swift
//  KarhooUISDKTests
//
//  Created by Bartlomiej Sopala on 02/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import XCTest
import KarhooUISDK
import KarhooUISDKTestUtils
@testable import KarhooUISDK

class MailValidatorTest: KarhooTestCase {
    
    private let correctEmail = "contact@karhoo.com"
    private let incorrectEmailMissingAt = "contact.karhoo.com"
    private let incorrectEmailMissingDomain = "contact@"
    private let incorrectEmailMissingprefix = "@karhoo.com"
    private let incorrectEmailEmpty = ""
    private let incorrectEmailDomainWithoutDot = "contact@karhoocom"
    private let incorrectEmailwithSpaceInMiddle = "contact @karhoocom"
    private let incorrectEmailwithSpaceAtBeginning = " contact@karhoocom"
    private let incorrectEmailwithSpaceAtEnd = "contact@karhoocom "
    
    let mailValidator = MailValidator()


    /**
     * Given: String with email addrees
     * When: Mail has correct format
     * Then: True should be returned
     */
    func testCorrectEmail() {
        let result = mailValidator.isValidMail(correctEmail)
        XCTAssertTrue(result)
    }
    
    /**
     * Given: String with email addrees
     * When: Mail has no "@"
     * Then: False should be returned
     */
    func testIncorrectEmailMissingAt() {
        let result = mailValidator.isValidMail(incorrectEmailMissingAt)
        XCTAssertFalse(result)
    }
    
    /**
     * Given: String with email addrees
     * When: Mail has no text after @
     * Then: False should be returned
     */
    func testIncorrectEmailMissingDomain() {
        let result = mailValidator.isValidMail(incorrectEmailMissingDomain)
        XCTAssertFalse(result)
    }
    
    /**
     * Given: String with email addrees
     * When: Mail has no text before "@"
     * Then: False should be returned
     */
    func testIncorrectEmailMissingprefix() {
        let result = mailValidator.isValidMail(incorrectEmailMissingprefix)
        XCTAssertFalse(result)
    }
    
    /**
     * Given: String with email addrees
     * When: String is empty
     * Then: False should be returned
     */
    func testIncorrectEmailEmpty() {
        let result = mailValidator.isValidMail(incorrectEmailEmpty)
        XCTAssertFalse(result)
    }
    
    /**
     * Given: String with email addrees
     * When: Mail has no dot after "@"
     * Then: False should be returned
     */
    func testIncorrectEmailDomainWithoutDot() {
        let result = mailValidator.isValidMail(incorrectEmailDomainWithoutDot)
        XCTAssertFalse(result)
    }
    
    /**
     * Given: String with email addrees
     * When: Mail has space in the middlie
     * Then: False should be returned
     */
    func testIncorrectEmailwithSpaceInMiddle() {
        let result = mailValidator.isValidMail(incorrectEmailwithSpaceInMiddle)
        XCTAssertFalse(result)
    }
    
    /**
     * Given: String with email addrees
     * When: Mail has space at the beginning
     * Then: False should be returned
     */
    func testIncorrectEmailwithSpaceAtBeginning() {
        let result = mailValidator.isValidMail(incorrectEmailwithSpaceAtBeginning)
        XCTAssertFalse(result)
    }
    
    /**
     * Given: String with email addrees
     * When: Mail has space at the end
     * Then: False should be returned
     */
    func testIincorrectEmailwithSpaceAtEnd() {
        let result = mailValidator.isValidMail(incorrectEmailwithSpaceAtEnd)
        XCTAssertFalse(result)
    }
 }
