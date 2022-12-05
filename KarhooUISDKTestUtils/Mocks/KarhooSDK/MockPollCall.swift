//
//  MockKarhooPollCall.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

public class MockPollCall<T: KarhooCodableModel>: PollCall<T> {

    public let mockObservable = MockObservable<T>()

    override public init(pollExecutor: KarhooPollExecutor) {
        super.init(pollExecutor: pollExecutor)
    }

    public init() {
        super.init(pollExecutor: MockKarhooPollExecutor())
    }

    public var hasObserver: Bool {
        return mockObservable.hasObserver
    }

    override public func observable(pollTime: TimeInterval) -> Observable<T> {
        return mockObservable
    }

    public func triggerPollSuccess(_ value: T) {
        mockObservable.triggerResult(result: .success(result: value))
        callback?(.success(result: value))
    }

    public func triggerPollFailure(_ error: KarhooError) {
        mockObservable.triggerResult(result: .failure(error: error))
    }

    public func triggerExecute(result: Result<T>) {
        self.callback?(result)
    }

    public var callback: CallbackClosure<T>?
    override public func execute(callback: @escaping CallbackClosure<T>) {
        super.execute(callback: callback as CallbackClosure<T>)
        self.callback = callback as CallbackClosure<T>
    }
}
