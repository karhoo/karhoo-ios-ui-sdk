//
//  URLOpener.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import KarhooSDK
import UIKit

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
        case .custom:  open(URL(string: "\(UITexts.TrackingLinks.stagingLink)\(followCode)")!)
        case .production: open(URL(string: "\(UITexts.TrackingLinks.productionLink)\(followCode)")!)
        case .sandbox: return open(URL(string: "\(UITexts.TrackingLinks.sandboxLink)\(followCode)")!)
        @unknown default:
            print("Unknown enum value in KarhooURLOpener.openAgentPortalTracker")
        }
    }
}
