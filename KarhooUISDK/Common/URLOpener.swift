//
//  KarhooURLOpener.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

public protocol URLOpener {
    func open(_: URL)
    func openAgentPortalTracker(followCode: String)
}

final public class KarhooURLOpener: URLOpener {

    public init() {}

    public func open(_ url: URL) {
        UIApplication.shared.open(url)
    }

    public func openAgentPortalTracker(followCode: String) {
        switch Karhoo.configuration.environment() {
        case .custom:  open(URL(string: "https://agent-portal.stg.karhoo.net/follow/\(followCode)")!)
        case .production: open(URL(string: "https://agent-portal.karhoo.com/follow/\(followCode)")!)
        case .sandbox: return open(URL(string: "https://agent-portal.karhoo.com/follow/\(followCode)")!)
        }
    }
}
