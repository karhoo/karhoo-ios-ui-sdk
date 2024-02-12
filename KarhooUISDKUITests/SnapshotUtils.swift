////
////  SnapshotUtils.swift
////  KarhooUISDKUITests
////
////  Created by Aleksander Wedrychowski on 03/11/2022.
////  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
////
//
import Foundation
import XCTest
import UIKit
import SnapshotTesting
import Nimble
import Quick

public func testSnapshot<View: UIView>(
    _ view: View,
    file: StaticString = #file,
    fileName: String = #function,
    line: UInt = #line
) {
    guard view.bounds.size != .zero else {
        fail("\(String(describing: view.self)) - size equals zero", file: file, line: line)
        return
    }
    guard let failureMessage = verifySnapshot(
        matching: view,
        as: .image,
        file: file,
        testName: QuickSpec.current?.name ?? fileName,
        line: line
    ) else { return }

    fail(failureMessage, file: file, line: line)
}

public func testSnapshot<ViewController: UIViewController>(
    _ viewController: ViewController,
    file: StaticString = #file,
    fileName: String = #function,
    line: UInt = #line
) {
    guard let failureMessage = verifySnapshot(
        matching: viewController,
        as: .wait(for: 0.1, on: .image(on: .iPhoneX)),
        file: file,
        testName: QuickSpec.current?.name ?? fileName,
        line: line
    ) else { return }

    fail(failureMessage, file: file, line: line)
}
