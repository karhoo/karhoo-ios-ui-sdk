//
//  UIColorHexSpec.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 13/01/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import XCTest
import KarhooUISDKTestUtils
@testable import KarhooUISDK

/// Due to Swift/iOS SDK limitations there is no quick way to test expected failures if tested code uses some sort of assertion (`assetionFrailure` or `assert`). To be done when some additional testing SDK will be integrated (Quick/Nimble for instance).
class UIColorHexSpec: KarhooTestCase {

    func testHexInitialization() {
        let hex = "#FF0000"
        let expectedColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)

        XCTAssert(UIColor(hex: hex) == expectedColor)
    }

    func testRandomHexInitialization() {
        let randomHex = "#12dasa"
        
        _ = UIColor(hex: randomHex)

        // The test succeded since assertion has been checked. In case of failure hex initialization would have stoped the scope execution.
        XCTAssertTrue(true)
    }
}
