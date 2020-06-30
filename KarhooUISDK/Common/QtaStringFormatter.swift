//
//  QtaStringFormatter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation

public struct QtaStringFormatter {

    public init() {}

    public func qtaString(min: Int?, max: Int?) -> String {
        if let max = max, let min = min {

            if min == 0 && max == 0 {
                return ""
            }

            if min == 0 || min == max {
                return "\(max) \(UITexts.Generic.minutes)"
            }

            return "\(min)-\(max) \(UITexts.Generic.minutes)"

        } else {
           return handleUnkownNil(min: min, max: max)
        }
    }

    private func handleUnkownNil(min: Int?, max: Int?) -> String {
        if let min = min {
             return "\(min) \(UITexts.Generic.minutes)"
        }

        if let max = max {
            return "\(max) \(UITexts.Generic.minutes)"
        }

        return ""
    }
}
