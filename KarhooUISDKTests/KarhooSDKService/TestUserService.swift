//
//  TestUserService.swift
//  Karhoo
//
//  Created by Jeevan Thandi on 22/05/2017.
//  Copyright © 2017 Flit Technologies LTD. All rights reserved.
//

import Foundation
import KarhooSDK

@testable import Karhoo

final class MockUserService: UserService {

    let loginUserCall = MockCall<UserInfo>(executable: MockExecutable())
    var loginUserLogin: UserLogin?
    func login(userLogin: UserLogin) -> Call<UserInfo> {
        loginUserLogin = userLogin
        return loginUserCall
    }

    let logoutCall = MockCall<KarhooVoid>(executable: MockExecutable())
    func logout() -> Call<KarhooVoid> {
        return logoutCall
    }

    let passwordResetCall = MockCall<KarhooVoid>(executable: MockExecutable())
    var passwordResetEmailSet: String?
    func passwordReset(email: String) -> Call<KarhooVoid> {
        passwordResetEmailSet = email
        return passwordResetCall
    }

    let registerCall = MockCall<UserInfo>(executable: MockExecutable())
    var userRegistrationSet: UserRegistration?
    func register(userRegistration: UserRegistration) -> Call<UserInfo> {
        userRegistrationSet = userRegistration
        return registerCall
    }

    var currentUserToReturn: UserInfo?
    var getCurrentUserCalled = false
    func getCurrentUser() -> UserInfo? {
        getCurrentUserCalled = true
        return currentUserToReturn
    }

    var lastObserverAdded: UserStateObserver?
    func add(observer: UserStateObserver) {
        lastObserverAdded = observer
    }

    var lastObserverRemoved: UserStateObserver?
    func remove(observer: UserStateObserver) {
        lastObserverRemoved = observer
    }

    func triggerUserStateChange(user: UserInfo?) {
        lastObserverAdded?.userStateUpdated(user: user)
    }
}
