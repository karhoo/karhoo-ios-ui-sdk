//
//  MockDateProvider.swift
//  KarhooUISDKTestUtils
//
//  Created by Aleksander Wedrychowski on 08/12/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

public class MockDateProvider: DateProvider {
    public init() {}

    public var now: Date { .mock() }
}

public extension Date {
    ///  2025-12-02 14:51:06 CET
    static func mock() -> Date {
        Date(timeIntervalSince1970: 1764683466.0)
    }
}
