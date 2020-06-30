//
//  MockKarhooPollCall.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

class MockPollCall<T: KarhooCodableModel>: PollCall<T> {

    let mockObservable = MockObservable<T>()

    override init(pollExecutor: KarhooPollExecutor) {
        super.init(pollExecutor: pollExecutor)
    }

    init() {
        super.init(pollExecutor: MockKarhooPollExecutor())
    }

    var hasObserver: Bool {
        return mockObservable.hasObserver
    }

    override func observable(pollTime: TimeInterval) -> Observable<T> {
        return mockObservable
    }

    func triggerPollSuccess(_ value: T) {
        mockObservable.triggerResult(result: .success(result: value))
        callback?(.success(result: value))
    }

    func triggerPollFailure(_ error: KarhooError) {
        mockObservable.triggerResult(result: .failure(error: error))
    }

    func triggerExecute(result: Result<T>) {
        self.callback?(result)
    }

    var callback: CallbackClosure<T>?
    override func execute(callback: @escaping CallbackClosure<T>) {
        super.execute(callback: callback as CallbackClosure<T>)
        self.callback = callback as CallbackClosure<T>
    }
}
