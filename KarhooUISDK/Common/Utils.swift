//
//  Utils.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import PhoneNumberKit

public class Utils {
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
}
