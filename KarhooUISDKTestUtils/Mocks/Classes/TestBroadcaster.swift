//
//  TestBroadcaster.swift
//  KarhooSDK
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK

public class TestBroadcaster: Broadcaster<AnyObject> {
    public var lastListenerAdded: AnyObject?
    public var lastListenerRemoved: AnyObject?

    override public func add(listener: AnyObject) {
        lastListenerAdded = listener
        super.add(listener: listener)
    }

    override public func remove(listener: AnyObject) {
        lastListenerRemoved = listener
        super.remove(listener: listener)
    }

    public var hasListenersReturnValue: Bool?
    override public func hasListeners() -> Bool {
        if hasListenersReturnValue == nil {
            return super.hasListeners()
        }

        return hasListenersReturnValue!
    }
}
