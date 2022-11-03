//
//  TestTimeScheduler.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooUISDK

final public class MockTimeScheduler: TimeScheduler {
    public enum TimeoutEvent: Equatable {
        case schedule(TimeInterval)
        case invalidate
        
        public static func == (lhs: TimeoutEvent, rhs: TimeoutEvent) -> Bool {
            switch (lhs, rhs) {
            case let(.schedule(lhsInterval), .schedule(rhsInterval)):
                return lhsInterval == rhsInterval
            case (.invalidate, .invalidate):
                return true
            default:
                return false
            }
        }
    }
    
    public var events: [TimeoutEvent] = []
    public var lastBlock: (() -> Void)?
    public var schuduleRepeats: Bool?
    public func schedule(block: @escaping () -> Void, in timeInterval: TimeInterval, repeats: Bool) {
        events.append(.schedule(timeInterval))
        lastBlock = block
        schuduleRepeats = repeats
    }
    
    public func fire() {
        lastBlock?()
    }
    
    public func invalidate() {
        events.append(.invalidate)
    }
}
