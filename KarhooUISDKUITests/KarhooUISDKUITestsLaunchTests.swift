//
//  KarhooUISDKUITestsLaunchTests.swift
//  KarhooUISDKUITests
//
//  Created by Aleksander Wedrychowski on 28/10/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import XCTest

final class KarhooUISDKUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
