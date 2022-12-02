//
//  MockContentView.swift
//  KarhooUISDKTests
//
//  Created by Matei Dediu on 05.05.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

final public class MockContentView: Screen, MenuContentView {
    public var calledShowGuestMenu = false
    
    public func getFlowItem() -> Screen {
        return self
    }
    
    public func showGuestMenu() {
        calledShowGuestMenu = true
    }
}
