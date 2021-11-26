//
//  TimeScheduler.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public protocol TimeScheduler {

    func schedule(block: @escaping () -> Void, in timeInterval: TimeInterval, repeats: Bool)

    func invalidate()
}
