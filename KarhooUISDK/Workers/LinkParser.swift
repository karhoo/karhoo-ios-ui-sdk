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

protocol LinkParserProtocol {
    func formatIsSupported(_ link: String) -> Bool
    func getLinkType(_ link: String) -> KarhooLinkType?
}

final class LinkParser: LinkParserProtocol {
    // MARK: - Variables
    private let mailValidator: MailValidatorProtocol
    private let urlStringValidator: UrlStringValidatorProtocol
    private let mailLinkPrefix = "mailto:"

    // MARK: - Init
    init(mailValidator: MailValidatorProtocol = MailValidator(), urlStringValidator: UrlStringValidatorProtocol = UrlStringValidator()) {
        self.mailValidator = mailValidator
        self.urlStringValidator = urlStringValidator
    }
    
    func formatIsSupported(_ link: String) -> Bool {
        return getLinkType(link) != nil
    }
    
    func getLinkType(_ link: String) -> KarhooLinkType? {
        if urlStringValidator.isCorrectUrl(addrees: link) {
            guard let url = URL(string: link) else {return nil}
            return .url(url: url)
        } else if String(link.prefix(mailLinkPrefix.count)) == mailLinkPrefix {
            let addrees = String(link.dropFirst(mailLinkPrefix.count))
            return mailValidator.isValidMail(addrees) ? .mail(addrees: addrees) : nil
        } else {
            return nil
        }
    }
}
