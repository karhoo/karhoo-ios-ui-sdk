//
//  KarhooTimeScheduler.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation

public final class KarhooTimeScheduler: TimeScheduler {
    private var timer: Timer?
    private var block: (() -> Void)?
    private var repeats: Bool?

    public init() { }

    public func schedule(block: @escaping () -> Void, in timeInterval: TimeInterval, repeats: Bool) {
        invalidate()
        self.block = block
        self.repeats = repeats

        timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                     target: self,
                                     selector: #selector(KarhooTimeScheduler.fire),
                                     userInfo: nil,
                                     repeats: repeats)
    }

    @objc private func fire() {
        block?()
    }

    public func invalidate() {
        timer?.invalidate()
        timer = nil
    }
}
