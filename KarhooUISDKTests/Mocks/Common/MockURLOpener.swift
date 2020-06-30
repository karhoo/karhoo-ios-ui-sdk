//
//  MockURLOpener.swift
//  KarhooUISDKTests
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
@testable import KarhooUISDK

final class MockURLOpener: URLOpener {

    func open(_: URL) {}

    var followCodeSet: String?
    func openAgentPortalTracker(followCode: String) {
        followCodeSet = followCode
    }
}
