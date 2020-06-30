//
//  TimeFetcher.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol TimeFetcher {
    func now() -> Date
}

class KarhooTimeFetcher: TimeFetcher {
    func now() -> Date {
        return Date()
    }
}
