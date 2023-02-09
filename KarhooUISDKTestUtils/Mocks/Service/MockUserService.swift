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

    public let updateUserCall = MockCall<UserInfo>(executable: MockExecutable())
    public func updateUserDetails(update: UserDetailsUpdateRequest) -> Call<UserInfo> {
        return updateUserCall
    }

    public let loginUserCall = MockCall<UserInfo>(executable: MockExecutable())
    public var loginUserLogin: UserLogin?
    public func login(userLogin: UserLogin) -> Call<UserInfo> {
        loginUserLogin = userLogin
        return loginUserCall
    }

    public let logoutCall = MockCall<KarhooVoid>(executable: MockExecutable())
    public func logout() -> Call<KarhooVoid> {
        return logoutCall
    }

    public let passwordResetCall = MockCall<KarhooVoid>(executable: MockExecutable())
    public var passwordResetEmailSet: String?
    public func passwordReset(email: String) -> Call<KarhooVoid> {
        passwordResetEmailSet = email
        return passwordResetCall
    }

    public let registerCall = MockCall<UserInfo>(executable: MockExecutable())
    public var userRegistrationSet: UserRegistration?
    public func register(userRegistration: UserRegistration) -> Call<UserInfo> {
        userRegistrationSet = userRegistration
        return registerCall
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
