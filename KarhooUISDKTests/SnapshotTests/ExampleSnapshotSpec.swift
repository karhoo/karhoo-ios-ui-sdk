//
//  ExampleSnapshotSpec.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 17/10/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import XCTest
import SnapshotTesting
import Quick
import Nimble
import UIKit
@testable import KarhooUISDKTestUtils
@testable import KarhooUISDK

class ExampleSnapshotSpec: QuickSpec {

    override func spec() {

        /// Define feature/method/view that is tested
        describe("Feature name") {
            // Define variables needed for all test cases in given spec. In most of the cases there will be the list of suts (tested objects) and mocks injected using dependency injection
            var sut1: UIView!
            var sut2: UIViewController!

            beforeEach {
                // modify test objects/mocks.
                // The closure will be fired before every single nested scope (`describe`, `context`, `it`). It should be used to define global state/environment and make sure one test does not affect any other.
                sut1 = UIView()
                sut2 = UIViewController()
            }

            /// Define specific preconditions or environment settings. Examples: user is logged in, user is not logged in.
            context("when... ") {
                beforeEach {
                    sut1.backgroundColor = .red
                    sut1.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                    sut2.view.backgroundColor = .blue
                    // modify test objects/mocks.
                    // The closure will be fired before every single nested scope (`describe`, `context`, `it`). It should be used to setup specific environment and make sure one test does not affect any other.
                }

                // if needed you can create additional nested context to test some specific use case
                context("and when user has no money") {
                    /// Define variables needed only for given context
                    let variableNeededOnlyForGivenContext = TestUtil()

                    beforeEach {
                        /// add code that modifies tested objects and their environment to mock given context
                        _ = variableNeededOnlyForGivenContext // only for silence the warning
                        sut1.backgroundColor = .green
                    }

                    it("should show proper design") {
                        testSnapshot(sut1)
                    }
                }

                // test specific requirement
                it("should...") {
                    /// actual assertion and test code goes here
                }

                // test another specific requirement - in this case view controller design
                it("should show proper design of view controller") {
                    testSnapshot(sut2)
                }

                // test another requirement - in this case sut1 design
                it("should show proper design of view") {
                    testSnapshot(sut1)
                }
            }
        }
    }
}
