//
//  MailValidator.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 02/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

protocol MailValidatorProtocol {
    func isValidMail(_ mail: String) -> Bool
}

final class MailValidator: MailValidatorProtocol {
    func isValidMail(_ mail: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: mail)
    }
}
