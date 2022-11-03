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
        fail("\(String(describing: view.self)) - size equals zero", file: file.description, line: line)
        return
    }
    guard let failureMessage = verifySnapshot(
        matching: view,
        as: .image,
        file: file,
        testName: QuickSpec.current?.name ?? fileName,
        line: line
    ) else { return }

    fail(failureMessage, file: file.description, line: line)
}

public func testSnapshot<ViewController: UIViewController>(
    _ viewController: ViewController,
    file: StaticString = #file,
    fileName: String = #function,
    line: UInt = #line
) {
    guard viewController.view.bounds.size != .zero else {
        fail("\(String(describing: ViewController.self)) - views's size equals zero", file: file.description, line: line)
        return
    }
    guard let failureMessage = verifySnapshot(
        matching: viewController.view,
        as: .image,
        file: file,
        testName: QuickSpec.current?.name ?? fileName,
        line: line
    ) else { return }

    fail(failureMessage, file: file.description, line: line)
}
