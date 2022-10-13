//
//  KarhooTestCase.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 27/05/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import XCTest
import SnapshotTesting
import Quick
import Nimble
import UIKit

@testable import KarhooUISDK

class KarhooTestCase: QuickSpec {

    override func spec() {
        var sut: UIView!
        var sut2: UIViewController!

        describe("Define general scope") {
            beforeEach {
                sut = UIView()
                sut2 = UIViewController()
                // modify test objects/mocks.
                // The closure will be fired before every single nested scope (`describe`, `context`, `it`). It should be used to define global state/environment and make sure one test does not affect any other.
            }

            context("Define specific preconditions or environment settings") {
                beforeEach {
                    sut.backgroundColor = .red
                    sut2.view.backgroundColor = .blue
                    // modify test objects/mocks.
                    // The closure will be fired before every single nested scope (`describe`, `context`, `it`). It should be used to setup specific environment and make sure one test does not affect any other.
                }

                it("test specific requirement") {
                }

                it("Test VC snapshot") {
                    self.assertSnapshot(sut2)
                }

                it("Test View snapshot") {
                    self.assertSnapshot(sut)
                }
            }


        }
    }
}

extension QuickSpec {

    func assertSnapshot<Value: UIView>(
        _ value: Value,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let result = verifySnapshot(
            matching: value,
            as: .image,
            named: self.name,
            snapshotDirectory: file.description
        )

        XCTAssertNil(result)
    }

    func assertSnapshot<Value: UIViewController>(
        _ value: Value,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let result1 = verifySnapshot(
            matching: value,
            as: .image(on: .iPhoneX),
            named: "iPhone - \(self.name)",
            snapshotDirectory: "\(file.description)/\(self.name)"
        )
        let result2 = verifySnapshot(
            matching: value,
            as: .image(on: .iPhoneXsMax),
            named: "iPhoneMax - \(self.name)",
            snapshotDirectory: "\(file.description)/\(self.name)"
        )

        XCTAssertNil(result1)
        XCTAssertNil(result2)
    }
}

