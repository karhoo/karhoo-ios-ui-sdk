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
    
    static func isValidPhoneNumber(number: String) -> Bool {
        /// check if number begins with country code (+XX) and the number itself has between 3 and 10 digits.
        let phoneNumberRegex = "^\\+\\d{1,3}[ -]?\\d{3,11}$"
        let phoneNumberPredicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)

        return phoneNumberPredicate.evaluate(with: number.replacingOccurrences(of: " ", with: ""))
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
