//
//  Utils.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import PhoneNumberKit
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
        if number.first != "+" {
            return false
        }

        let phoneNumberKit = PhoneNumberKit()
        do {
            _ = try phoneNumberKit.parse(number)
            return true
        } catch {
            print("Phone number invalid")
            return false
        }
    }

    static func convertToDictionary(data: Data) -> [String: Any]? {
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
}

class ViewControllerUtils {
    static var topBaseViewController: BaseViewController? {
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while topVC!.presentedViewController != nil {
             topVC = topVC!.presentedViewController
        }
        return topVC as? BaseViewController
    }
    
    static var topViewController: UIViewController? {
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while topVC!.presentedViewController != nil {
             topVC = topVC!.presentedViewController
        }
        return topVC
    }
}
