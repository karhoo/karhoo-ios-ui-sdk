//
//  MockKarhooPollableExecutor.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

final public class MockKarhooPollExecutor: KarhooPollExecutor {

    private let mockExecutable: MockExecutable
    init(executable: MockExecutable = MockExecutable()) {
        self.mockExecutable = executable
    }

    public func set(pollTime: TimeInterval) {}

    public func stopPolling() {}

    public var executable: KarhooExecutable {
        return self.mockExecutable
    }

    public var startedPolling = false
    private var pollingCallback: CallbackClosure<Any>?
    public func startPolling<T>(pollTime: TimeInterval, callback: @escaping CallbackClosure<T>) {
        startedPolling = true
        pollingCallback = { (result: Result<Any>) -> Void in
            if let value = result.getSuccessValue() as? T {
                callback(.success(result: value))
            } else {
                callback(.failure(error: result.getErrorValue()))
            }
        }
    }

    public func triggerSuccess<T: KarhooCodableModel>(_ value: T) {
        pollingCallback?(.success(result: value))
    }

    public func triggerFail(_ error: KarhooError) {
        pollingCallback?(.failure(error: error))
    }
}
