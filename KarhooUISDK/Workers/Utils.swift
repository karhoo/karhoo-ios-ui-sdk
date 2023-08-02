//
//  Utils.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import UIKit

public class Utils {
    // The unicode values are possible variations for apostrophe / single quote
    private static let acceptedNameChars = ["-", "\u{0027}", "\u{2018}", "\u{2019}", ".", " "]

    static func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailPred.evaluate(with: email)
    }
    
    static func isValidPhoneNumber(number: String, countryCode: String = "") -> Bool {
        let rule = KarhooCountryPhoneValidationRuleProvider.shared.getRule(for: countryCode)
        var phoneNumber = number
        // The country specific rules defined in country_phone_validation_rules.json do not account for the prefix.
        // The check will fail if the prefix is left in place in case of one of those countries
        // On the other hand, any country not on the list will be compared against the default rule, which requires the prefix
        if rule.internationalPhonePrefix.isNotEmpty, phoneNumber.starts(with: "+\(rule.internationalPhonePrefix)") {
            phoneNumber = phoneNumber.removePrefix("+\(rule.internationalPhonePrefix)")
        }
        
        let nationalPrefix = rule.nationalPhonePrefix
        if nationalPrefix.isNotEmpty, phoneNumber.starts(with: nationalPrefix) {
            phoneNumber = phoneNumber.removePrefix(nationalPrefix)
        }
        let phoneNumberPredicate = NSPredicate(format: "SELF MATCHES %@", rule.mobileValidationRegex)
        return phoneNumberPredicate.evaluate(with: phoneNumber.replacingOccurrences(of: " ", with: ""))
    }

    public static func convertToDictionary(data: Data) -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }

        return ["": ""]
    }
    
    static func isValidName(name: String?) -> Bool {
        guard let name = name, !name.isEmpty, name.count >= 2 else {
            return false
        }

        for char in name {
            guard char.isLetter || acceptedNameChars.contains(String(char))
            else {
                return false
            }
        }
        
        return true
    }
    
    static func isAplhanumerical(_ text: String) -> Bool {
        for char in text {
            if !char.isLetter && !char.isNumber {
                return false
            }
        }
        return true
    }
}

class ViewControllerUtils {
    static var topBaseViewController: BaseViewController? {
        var topVC = UIApplication.shared.windows.first?.rootViewController
        while topVC!.presentedViewController != nil {
             topVC = topVC!.presentedViewController
        }
        return topVC as? BaseViewController
    }
    
    static var topViewController: UIViewController? {
        var topVC = UIApplication.shared.windows.first?.rootViewController
        while topVC!.presentedViewController != nil {
             topVC = topVC!.presentedViewController
        }
        return topVC
    }
}
