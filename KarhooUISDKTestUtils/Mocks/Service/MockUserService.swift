//
//  MockUserServiceMockUserService.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK

@testable import KarhooUISDK

final public class MockUserService: UserService {

    public init() {}

    public let logoutCall = MockCall<KarhooVoid>(executable: MockExecutable())
    public func logout() -> Call<KarhooVoid> {
        return logoutCall
    }

    public var currentUserToReturn: UserInfo = TestUtil.getRandomUser()
    public var getCurrentUserCalled = false
    public func getCurrentUser() -> UserInfo? {
        getCurrentUserCalled = true
        return currentUserToReturn
    }

    public var lastObserverAdded: UserStateObserver?
    public func add(observer: UserStateObserver) {
        lastObserverAdded = observer
    }

    public var lastObserverRemoved: UserStateObserver?
    public func remove(observer: UserStateObserver) {
        lastObserverRemoved = observer
    }

    public func triggerUserStateChange(user: UserInfo?) {
        lastObserverAdded?.userStateUpdated(user: user)
    }
}
