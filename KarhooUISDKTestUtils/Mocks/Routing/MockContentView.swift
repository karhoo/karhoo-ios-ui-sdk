//
//  MockContentView.swift
//  KarhooUISDKTests
//
//  Created by Matei Dediu on 05.05.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

final class MockContentView: Screen, MenuContentView {
    var calledShowGuestMenu = false
    
    func getFlowItem() -> Screen {
        return self
    }
    
    func showGuestMenu() {
        calledShowGuestMenu = true
    }
}
