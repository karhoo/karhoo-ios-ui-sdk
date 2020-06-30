//
//  MockCall.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

class MockCall<T: KarhooCodableModel>: Call<T> {

    private var callback: ((Result<T>) -> Void)?
    public var executed: Bool = false

    override init(executable: KarhooExecutable) {
        super.init(executable: executable)
    }

    init() {
        super.init(executable: MockExecutable())
    }

    override func execute(callback: @escaping (Result<T>) -> Void) {
        self.executed = true
        self.callback = callback
    }

    func triggerResult(result: Result<T>) {
        callback?(result)
    }

    func triggerSuccess(_ value: T) {
        callback?(.success(result: value))
    }

    func triggerFailure(_ error: KarhooError) {
        callback?(.failure(error: error))
    }
}
