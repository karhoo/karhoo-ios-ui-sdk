//
//  MockOriginEtaView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

final class MockOriginEtaView: OriginEtaView {
   
    func start(tripId: String) {}
    
    func stop() {}
    
    var showEtaSet: String?
    func show(eta: String) {
        showEtaSet = eta
    }
    
    var hideEtaCalled = false
    func hide() {
        hideEtaCalled = true
    }
}
