//
//  KarhooDateFormatter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation

protocol DateFormatterType {
    func set(timeZone: TimeZone)
    func set(locale: Locale)

    func display(shortStyleTime date: Date?) -> String
    func display(mediumStyleDate date: Date?) -> String
    func display(shortDate date: Date?) -> String
    func display(detailStyleDate date: Date?) -> String
    func display(fullDate date: Date?) -> String
    func display(clockTime date: Date?) -> String
    func display(
        _ date: Date?,
        dateStyle: DateFormatter.Style,
        timeStyle: DateFormatter.Style
    ) -> String
}

class KarhooDateFormatter: DateFormatterType {

    private let dateFormatter = DateFormatter()
    private var timeZone: TimeZone
    private var locale: Locale

    init(
        timeZone: TimeZone = TimeZone.current,
        locale: Locale = Locale.current
    ) {
        self.locale = locale
        self.timeZone = timeZone
    }

    func set(timeZone: TimeZone) {
        self.timeZone = timeZone
    }

    func set(locale: Locale) {
        self.locale = locale
    }

    func display(
        _ date: Date?,
        dateStyle: DateFormatter.Style,
        timeStyle: DateFormatter.Style
    ) -> String {
        guard let date = date else {
            return ""
        }

        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        return dateFormatter.string(from: date)
    }

    func display(shortStyleTime date: Date?) -> String {
        guard let date = date else {
            return ""
        }

        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        return dateFormatter.string(from: date)
    }

    func display(mediumStyleDate date: Date?) -> String {
        guard let date = date else {
            return ""
        }

        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        return dateFormatter.string(from: date)
    }

    func display(shortDate date: Date?) -> String {
        guard let date = date else {
            return ""
        }
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        return dateFormatter.string(from: date)
    }

    func display(detailStyleDate date: Date?) -> String {
        guard let date = date else {
            return ""
        }

        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        return dateFormatter.string(from: date)
    }

    func display(fullDate date: Date?) -> String {
        guard let date = date else {
            return ""
        }
        dateFormatter.timeStyle = .full
        dateFormatter.dateStyle = .full
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        return dateFormatter.string(from: date)
    }

    func display(clockTime date: Date?) -> String {
        guard let date = date else {
            return ""
        }
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        return dateFormatter.string(from: date)
    }
}
