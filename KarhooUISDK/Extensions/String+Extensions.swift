//
//  String+Extensions.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//
import Foundation

extension String {

    var isWhitespace: Bool {
        replacingOccurrences(of: " ", with: "").isEmpty
    }
    
    /// Removes le last instance of the duplicate
    /// - Parameters:
    ///   - caseInsensitive: provides a way to decide how strict or loose the search should be in regards to case. Default value is true
    ///   - prettify: when set to true the method also removes any remaining extra commas and spaces using the " +, +" pattern. Default value is true
    /// - Returns: the initial string if the substring is not provided or not found, else the string striped of its substring (and possibly leftover bits depending on the prettify param)
    func remove(substring: String?, caseInsensitive: Bool = true, prettify: Bool = true) -> String {
        guard let substring,
              self.contains(substring) else {
            return self
        }
        
        let options: String.CompareOptions = caseInsensitive ? [.backwards, .caseInsensitive] : [.backwards]
        
        guard let range = self.range(of: substring, options: options) else {
            return self
        }
        
        let result = self.replacingCharacters(in: range, with: "")
        
        // if prettify clean up any instances of leftover commas in the middle of the string before returning the result
        return prettify ? result.removeSubstringWithRegexUsing(pattern: " +, +") : result
    }
    
    /// Removes the substring based on the NSRegularExpression pattern provided
    /// Throws a preconditionFailure during develoopment in case of invalid pattern
    /// Safe to use with emoji and similar
    func removeSubstringWithRegexUsing(pattern: String) -> String {
        var regex: NSRegularExpression!
        
        do {
            regex = try NSRegularExpression(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
        
        // It uses the utf16 count to avoid problems with emoji and similar
        let range = NSRange(location: 0, length: self.utf16.count)
        let result = regex.stringByReplacingMatches(in: self, range: range, withTemplate: " ")
        return result
    }
}
