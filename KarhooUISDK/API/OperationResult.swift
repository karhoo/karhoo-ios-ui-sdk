//
//  OperationResult.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public enum OperationResult<Value> {

    case completed(value: Value)
    case cancelledByUser

    public func completedValue() -> Value? {
        switch self {
        case .completed(let value): return value
        default: return nil
        }
    }
}
