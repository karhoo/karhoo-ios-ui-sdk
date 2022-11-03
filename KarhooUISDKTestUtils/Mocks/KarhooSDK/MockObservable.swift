//
//  MockKarhooObservable.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

public class MockObservable<T: KarhooCodableModel>: Observable<T> {

    public var hasObserver: Bool = false
    private var observer: Observer<T>?

    public init() {
        super.init(pollExecutor: MockKarhooPollExecutor(),
                   pollTime: 5)
    }

    public override func subscribe(observer: Observer<T>) {
        hasObserver = true
        self.observer = observer
    }

    public var unsubscribeCalled = false
    public override func unsubscribe(observer: Observer<T>) {
        hasObserver = false
        unsubscribeCalled = true
    }

    public func triggerResult(result: Result<T>) {
        observer?.closure(result)
    }
}
