//
//  LinkParserTest.swift
//  KarhooUISDKTests
//
//  Created by Bartlomiej Sopala on 02/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import XCTest
import KarhooUISDK
@testable import KarhooUISDK


class LinkParserTest: XCTestCase {
    
    private let linkParser = LinkParser(mailValidator: MailValidator(), urlStringValidator: UrlStringValidator())
    
    private let correctLink = "https://www.karhoo.com"
    private let linkWithoutHttps = "www.karhoo.com"
    private let correctMailLink = "mailto:contact@karhoo.com"
    private let mailLinkWithoutPrefix = "contact@karhoo.com"

    
    /**
     * Given: String containing correct url string
     * When: URL has correct format
     * Then: KarhooLinkType.url should be returned
     */
    func testCorrectUrl() {
        let result = linkParser.getLinkType(correctLink)
        switch result {
        case .url(url: _):
            break
        case .mail(addrees: _):
            XCTFail("Parser should return .url type")
        case nil:
            XCTFail("Parser should return .url type")
        }
    }
    
    /**
     * Given: String containing  url string without https:// prefix
     * When: URL has no https://
     * Then: nil should be returned
     */
    func testUrlStrnigWithoutHttps() {
        let result = linkParser.getLinkType(linkWithoutHttps)
        
        switch result {
        case .url(url: _) :
            XCTFail("Parser should return nil, http:// is expected as a prafix")
        case .mail(addrees: _):
            XCTFail("Parser should return nil")
        case nil:
            break;
        }
    }
    
    /**
     * Given: String containing email link
     * When: String contains email with mailto: prefix
     * Then: KarhooLinkType.mail should be returned
     */
    func testCorrectEmail() {
        let result = linkParser.getLinkType(correctMailLink)
        
        switch result {
        case .url(url: _) :
            XCTFail("Parser should return .mail")
        case .mail(addrees: _):
            break
        case nil:
            XCTFail("Parser should return .mail")
        }
    }
    
    
    /**
     * Given: String containing email
     * When: String contains email without mailto: prefix
     * Then: nil should be returned
     */
    func testEmailWithoutPrefix() {
        let result = linkParser.getLinkType(mailLinkWithoutPrefix)
        switch result {
        case .url(url: _) :
            XCTFail("Parser should return nil")
        case .mail(addrees: _):
            XCTFail("Parser should return nil")
        case nil:
            break
        }
    }
}
    
    
    
