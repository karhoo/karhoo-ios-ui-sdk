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
    guard let failureMessage = verifySnapshot(
      matching: view,
      as: .image,
      file: file,
      testName: QuickSpec.current?.name ?? fileName,
      line: line
    ) else { return }

    XCTFail(failureMessage, file: file, line: line)
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
    [.iPhoneX, .iPhoneXsMax]
        .compactMap {
            verifySnapshot(
                matching: viewController,
                as: .image(on: $0),
                file: file,
                testName: QuickSpec.current?.name ?? fileName,
                line: line
            )
        }
        .forEach { failureMessage in
            XCTFail(failureMessage, file: file, line: line)
        }
}
