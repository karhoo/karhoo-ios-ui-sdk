//
//  NSAttributedString+Utils.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

extension NSAttributedString {

    var all: NSRange {
        return NSRange(location: 0, length: self.length)
    }

    func matchesForString(_ string: String, usingRegex: Bool = false)
        -> [NSTextCheckingResult]? {
            var options: NSRegularExpression.Options

            if !usingRegex {
                options = .ignoreMetacharacters
            } else {
                options = .caseInsensitive
            }

            do {
                let exp = try NSRegularExpression(pattern: string, options: options)
                return exp.matches(in: self.string, options: .reportCompletion, range: self.all)
            } catch {
                return []
            }
    }
}

extension NSMutableAttributedString {

    func addAttribute(_ attribute: NSAttributedString.Key,
                      value: AnyObject,
                      forStrings string: String,
                      usingRegex: Bool = false) {
        addAttribute(attribute, value: value,
                     forMatches: matchesForString(string, usingRegex: usingRegex))
    }

    func setAttributes(_ attributes: [NSAttributedString.Key: AnyObject],
                       forStrings string: String,
                       usingRegex: Bool = false) {
        setAttributes(attributes,
                      forMatches: matchesForString(string, usingRegex: usingRegex))
    }

    func setAttributes(_ attributes: [NSAttributedString.Key: AnyObject]) -> NSMutableAttributedString {
        self.setAttributes(attributes, range: self.all)
        return self
    }

    @discardableResult
    func font(_ font: UIFont,
              forStrings string: String? = nil,
              usingRegex: Bool = false) -> NSMutableAttributedString {

        if let string = string {
            self.addAttribute(NSAttributedString.Key.font,
                              value: font,
                              forMatches: matchesForString(string, usingRegex: usingRegex))
        } else {
            self.addAttribute(NSAttributedString.Key.font, value: font, range: self.all)
        }
        return self
    }

    @discardableResult
    func textColor(_ value: UIColor,
                   forStrings string: String? = nil,
                   usingRegex: Bool = false) -> NSMutableAttributedString {

        if let string = string {
            self.setAttributes([NSAttributedString.Key.foregroundColor: value],
                               forMatches: matchesForString(string, usingRegex: usingRegex))
        } else {
            self.addAttribute(NSAttributedString.Key.foregroundColor,
                              value: value,
                              range: self.all)
        }
        return self
    }

    private func addAttribute(_ attribute: NSAttributedString.Key,
                              value: Any,
                              forMatches matches: [NSTextCheckingResult]?) {

        guard let checkedMatches = matches else {
            return
        }

        for match in checkedMatches {
            self.addAttribute(attribute, value: value, range: match.range)
        }
    }

    private func setAttributes(_ attributes: [NSAttributedString.Key: Any],
                               forMatches matches: [NSTextCheckingResult]?) {

        guard let checkedMatches = matches else {
            return
        }

        for match in checkedMatches {
            self.setAttributes(attributes, range: match.range)
        }
    }
}
