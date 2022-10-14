//
//  Snapshot+testSnapshot.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 14/10/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import XCTest
import UIKit
import SnapshotTesting
import Quick

func testSnapshot<View: UIView>(
    _ view: View,
    file: StaticString = #file,
    fileName: String = #function,
    line: UInt = #line
) {
    guard view.bounds.size != .zero else {
        XCTFail("\(String(describing: View.self)) - size is equal to zero", file: file, line: line)
        return
    }
    let failure = verifySnapshot(
      matching: view,
      as: .image,
      file: file,
      testName: QuickSpec.current?.name ?? fileName,
      line: line
    )
    guard let message = failure else { return }
    XCTFail(message, file: file, line: line)
}

func testSnapshot<ViewController: UIViewController>(
    _ viewController: ViewController,
    file: StaticString = #file,
    fileName: String = #function,
    line: UInt = #line
) {
    guard viewController.view.bounds.size != .zero else {
        XCTFail("\(String(describing: ViewController.self)) - views's size equals zero", file: file, line: line)
        return
    }
    let test1Failure = verifySnapshot(
      matching: viewController,
      as: .image(on: .iPhoneX),
      file: file,
      testName: QuickSpec.current?.name ?? fileName,
      line: line
    )
    let test2Failure = verifySnapshot(
      matching: viewController,
      as: .image(on: .iPhoneXsMax),
      file: file,
      testName: QuickSpec.current?.name ?? fileName,
      line: line
    )

    if let message = test1Failure {
        XCTFail(message, file: file, line: line)
    }

    if let message = test2Failure {
        XCTFail(message, file: file, line: line)
    }
}
