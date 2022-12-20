//
//  MockCall.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

public class MockCall<T: KarhooCodableModel>: Call<T> {

    private var callback: ((Result<T>) -> Void)?
    public var executed: Bool = false

    override public init(executable: KarhooExecutable) {
        super.init(executable: executable)
    }

    public init() {
        super.init(executable: MockExecutable())
    }

    override public func execute(callback: @escaping (Result<T>) -> Void) {
        self.executed = true
        self.callback = callback
    }

    public func triggerResult(result: Result<T>) {
        callback?(result)
    }

    public func triggerSuccess(_ value: T) {
        callback?(.success(result: value))
    }

    public func triggerFailure(_ error: KarhooError) {
        callback?(.failure(error: error))
    }
}
