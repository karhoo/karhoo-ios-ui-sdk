//
//  LinkParser.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 02/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

enum KarhooLinkType {
    case url(url: URL)
    case mail(addrees: String)
}

final class LinkParser {
    //MARK: - Variables
    private let mailValidator: MailValidatorProtocol
    private let mailLinkPrefix = "mailto:"

    //MARK: - Init
    init(mailValidator: MailValidatorProtocol) {
        self.mailValidator = mailValidator
    }
    
    func getLinkType(_ link: String) -> KarhooLinkType? {
        if let url = URL(string: link) {
            return .url(url: url)
        } else if String(link.prefix(mailLinkPrefix.count)) == mailLinkPrefix {
            let addrees = String(link.dropFirst(mailLinkPrefix.count))
            return mailValidator.isValidMail(addrees) ? .mail(addrees: addrees) : nil
        } else {
            return nil
        }
    }
}


