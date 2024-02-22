//
//  KarhooTestCase.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 27/05/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import KarhooUISDK
import KarhooUISDKTestUtils
import XCTest

class KarhooTestCase: XCTestCase {

    override func setUp() {
        super.setUp()
        KarhooUI.set(configuration: KarhooTestConfiguration())
    }
}
