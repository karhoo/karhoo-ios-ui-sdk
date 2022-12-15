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


