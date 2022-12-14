//
//  MockOriginEtaView.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
@testable import KarhooUISDK

final public class MockOriginEtaView: OriginEtaView {
   
    public func start(tripId: String) {}
    
    public func stop() {}
    
    public var showEtaSet: String?
    public func show(eta: String) {
        showEtaSet = eta
    }
    
    public var hideEtaCalled = false
    public func hide() {
        hideEtaCalled = true
    }
}
