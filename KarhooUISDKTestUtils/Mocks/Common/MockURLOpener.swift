//
//  MockURLOpener.swift
//  KarhooUISDKTests
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
@testable import KarhooUISDK

final public class MockURLOpener: URLOpener {

    public func open(_: URL) {}

    public var followCodeSet: String?
    public func openAgentPortalTracker(followCode: String) {
        followCodeSet = followCode
    }
}
