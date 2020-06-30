//
//  DebugLogger.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation

public class DebugLogger: Logger {
    public init() {}

    public func log(_ message: String) {
        #if DEBUG
            print(message)
        #endif
    }
}
