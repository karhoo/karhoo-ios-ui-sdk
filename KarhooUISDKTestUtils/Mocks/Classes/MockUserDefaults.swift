//
//  MockUserDefaults.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final public class MockUserDefaults: UserDefaults {

    public var synchronizeCalled = false
    override public func synchronize() -> Bool {
        synchronizeCalled = true
        return super.synchronize()
    }

    public var setForKeyCalled = false
    public var valueSet: Any?
    override public func set(_ value: Any?, forKey defaultName: String) {
        super.set(value, forKey: defaultName)
        setForKeyCalled = true
        self.valueSet = value
    }

    public var boolKeyValueSet: String?
    public var boolValueSet: Bool?
    override public func set(_ value: Bool, forKey defaultName: String) {
        boolKeyValueSet = defaultName
        boolValueSet = value
    }

    public var boolToReturn: Bool?
    override public func bool(forKey defaultName: String) -> Bool {
        return boolToReturn!
    }

    public var removePersistentDomainCalled = false
    override public func removePersistentDomain(forName domainName: String) {
        removePersistentDomainCalled = true
    }

    public var valueToReturn: Any?
    override public func value(forKey key: String) -> Any? {
        super.value(forKey: key)
        return valueToReturn
    }
}
