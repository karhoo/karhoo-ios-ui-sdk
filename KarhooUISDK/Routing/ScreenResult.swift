//
//  ScreenResult.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

public enum ScreenBuilderResult {
    case built(screen: Screen)
    case failed(error: KarhooUIError)

    public func screen() -> Screen? {
        switch self {
        case .built(let screen): return screen
        default: return nil
        }
    }

    public func error() -> KarhooUIError? {
        switch self {
        case .failed(let error): return error
        default: return nil
        }
    }
}

public enum ScreenResult<T> {
    case completed(result: T)
    case cancelled(byUser: Bool)
    case failed(error: KarhooError?)

    public func errorValue() -> KarhooError? {
        switch self {
        case .failed(let error):
            return error

        default:
            return nil
        }
    }

   public func completedValue() -> T? {
        switch self {
        case .completed(let result):
            return result

        default:
            return nil
        }
    }

    func isComplete() -> Bool {
        if case .completed = self {
            return true
        }
        return false
    }

    func isCancelled() -> Bool {
        if case .cancelled = self {
            return true
        }
        return false
    }

    func isCancelledByUser() -> Bool {
        if case .cancelled(let byUser) = self {
            return byUser
        }
        return false
    }

    func isFailure() -> Bool {
        if case .failed = self {
            return true
        }
        return false
    }
}

public typealias ScreenResultCallback<T> = (ScreenResult<T>) -> Void
