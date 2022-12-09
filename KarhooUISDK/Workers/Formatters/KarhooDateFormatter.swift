//
//  KarhooDateFormatter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation

@available(*, deprecated, message: "The protocol will not be `public` from next SDK vesion")
public protocol DateFormatterType {
    func set(timeZone: TimeZone)
    func set(locale: Locale)

    func display(shortStyleTime date: Date?) -> String
    func display(mediumStyleDate date: Date?) -> String
    func display(shortDate date: Date?) -> String
    func display(detailStyleDate date: Date?) -> String
    func display(fullDate date: Date?) -> String
    func display(clockTime date: Date?) -> String
}

public class KarhooDateFormatter: DateFormatterType {

    private let dateFormatter = DateFormatter()
    private var timeZone: TimeZone
    private var locale: Locale

    public init(timeZone: TimeZone = TimeZone.current,
                locale: Locale = Locale.current) {
        self.locale = locale
        self.timeZone = timeZone
    }

    public func set(timeZone: TimeZone) {
        self.timeZone = timeZone
    }

    public func set(locale: Locale) {
        self.locale = locale
    }

    @available(*, deprecated, message: "")
    public func display(shortStyleTime date: Date?) -> String {
        guard let date = date else {
            return ""
        }

        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        return dateFormatter.string(from: date)
    }

    @available(*, deprecated, message: "")
    public func display(mediumStyleDate date: Date?) -> String {
        guard let date = date else {
            return ""
        }

        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        return dateFormatter.string(from: date)
    }

    public func display(shortDate date: Date?) -> String {
        guard let date = date else {
            return ""
        }
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        return dateFormatter.string(from: date)
    }

    public func display(detailStyleDate date: Date?) -> String {
        guard let date = date else {
            return ""
        }

        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        return dateFormatter.string(from: date)
    }

    public func display(fullDate date: Date?) -> String {
        guard let date = date else {
            return ""
        }
        dateFormatter.timeStyle = .full
        dateFormatter.dateStyle = .full
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        return dateFormatter.string(from: date)
    }

    public func display(clockTime date: Date?) -> String {
        guard let date = date else {
            return ""
        }
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        return dateFormatter.string(from: date)
    }
}
