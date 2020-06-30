//
//  MockUserDefaults.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class MockUserDefaults: UserDefaults {

    var synchronizeCalled = false
    override func synchronize() -> Bool {
        synchronizeCalled = true
        return super.synchronize()
    }

    var setForKeyCalled = false
    var valueSet: Any?
    override func set(_ value: Any?, forKey defaultName: String) {
        super.set(value, forKey: defaultName)
        setForKeyCalled = true
        self.valueSet = value
    }

    var boolKeyValueSet: String?
    var boolValueSet: Bool?
    override func set(_ value: Bool, forKey defaultName: String) {
        boolKeyValueSet = defaultName
        boolValueSet = value
    }

    var boolToReturn: Bool?
    override func bool(forKey defaultName: String) -> Bool {
        return boolToReturn!
    }

    private(set) var removePersistentDomainCalled = false
    override func removePersistentDomain(forName domainName: String) {
        removePersistentDomainCalled = true
    }

    var valueToReturn: Any?
    override func value(forKey key: String) -> Any? {
        super.value(forKey: key)
        return valueToReturn
    }
}
