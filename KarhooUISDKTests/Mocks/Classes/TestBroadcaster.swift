//
//  TestBroadcaster.swift
//  KarhooSDK
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK

class TestBroadcaster: Broadcaster<AnyObject> {
    var lastListenerAdded: AnyObject?
    var lastListenerRemoved: AnyObject?

    override func add(listener: AnyObject) {
        lastListenerAdded = listener
        super.add(listener: listener)
    }

    override func remove(listener: AnyObject) {
        lastListenerRemoved = listener
        super.remove(listener: listener)
    }

    var hasListenersReturnValue: Bool?
    override func hasListeners() -> Bool {
        if hasListenersReturnValue == nil {
            return super.hasListeners()
        }

        return hasListenersReturnValue!
    }
}
