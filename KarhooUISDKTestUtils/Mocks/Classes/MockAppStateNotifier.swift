//
//  MockAppStateNotifier.swift
//  Karhoo
//
//
//  Copyright © 2017 Wyszo. All rights reserved.
//

import Foundation
import KarhooSDK

final public class MockAppStateNotifier: AppStateNotifierProtocol {

    public var listeners = [AppStateChangeDelegate?]()

    public var registrationsCount = 0
    public func register(listener: AppStateChangeDelegate) {
        listeners.append(listener)
        registrationsCount += 1
    }

    public var removalCount = 0
    public func remove(listener: AppStateChangeDelegate) {
        listeners = listeners.filter { $0 !== listener }
        removalCount += 1
    }

    public func signalAppDidBecomeActive() {
        listeners.forEach { $0?.appDidBecomeActive() }
    }

    public func signalAppWillResignActive() {
        listeners.forEach { $0?.appWillResignActive() }
    }

    public func signalAppDidEnterBackground() {
        listeners.forEach { $0?.appDidEnterBackground() }
    }
}
