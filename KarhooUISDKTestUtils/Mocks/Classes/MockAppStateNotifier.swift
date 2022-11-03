//
//  MockAppStateNotifier.swift
//  Karhoo
//
//
//  Copyright © 2017 Wyszo. All rights reserved.
//

import Foundation
import KarhooSDK

final class MockAppStateNotifier: AppStateNotifierProtocol {

    private(set) var listeners = [AppStateChangeDelegate?]()

    private(set) var registrationsCount = 0
    func register(listener: AppStateChangeDelegate) {
        listeners.append(listener)
        registrationsCount += 1
    }

    private(set) var removalCount = 0
    func remove(listener: AppStateChangeDelegate) {
        listeners = listeners.filter { $0 !== listener }
        removalCount += 1
    }

    func signalAppDidBecomeActive() {
        listeners.forEach { $0?.appDidBecomeActive() }
    }

    func signalAppWillResignActive() {
        listeners.forEach { $0?.appWillResignActive() }
    }

    func signalAppDidEnterBackground() {
        listeners.forEach { $0?.appDidEnterBackground() }
    }
}
