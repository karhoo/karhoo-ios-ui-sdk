//
//  MockKarhooPollableExecutor.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

final class MockKarhooPollExecutor: KarhooPollExecutor {

    private let mockExecutable: MockExecutable
    init(executable: MockExecutable = MockExecutable()) {
        self.mockExecutable = executable
    }

    func set(pollTime: TimeInterval) {}

    func stopPolling() {}

    var executable: KarhooExecutable {
        return self.mockExecutable
    }

    var startedPolling = false
    private var pollingCallback: CallbackClosure<Any>?
    func startPolling<T>(pollTime: TimeInterval, callback: @escaping CallbackClosure<T>) {
        startedPolling = true
        pollingCallback = { (result: Result<Any>) -> Void in
            if let value = result.getSuccessValue() as? T {
                callback(.success(result: value))
            } else {
                callback(.failure(error: result.getErrorValue()))
            }
        }
    }

    func triggerSuccess<T: KarhooCodableModel>(_ value: T) {
        pollingCallback?(.success(result: value))
    }

    func triggerFail(_ error: KarhooError) {
        pollingCallback?(.failure(error: error))
    }
}
