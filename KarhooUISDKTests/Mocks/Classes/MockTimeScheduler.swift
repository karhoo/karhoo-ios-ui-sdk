//
//  TestTimeScheduler.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooUISDK

final class MockTimeScheduler: TimeScheduler {
    enum TimeoutEvent: Equatable {
        case schedule(TimeInterval)
        case invalidate
        
        public static func == (lhs: TimeoutEvent, rhs: TimeoutEvent) -> Bool {
            switch (lhs, rhs) {
            case let (.schedule(lhsInterval), .schedule(rhsInterval)):
                return lhsInterval == rhsInterval
            case (.invalidate, .invalidate):
                return true
            default:
                return false
            }
        }
    }
    
    private(set) var events: [TimeoutEvent] = []
    private(set) var lastBlock: (() -> Void)?
    private(set) var schuduleRepeats: Bool?
    func schedule(block: @escaping () -> Void, in timeInterval: TimeInterval, repeats: Bool) {
        events.append(.schedule(timeInterval))
        lastBlock = block
        schuduleRepeats = repeats
    }
    
    func fire() {
        lastBlock?()
    }
    
    func invalidate() {
        events.append(.invalidate)
    }
}
