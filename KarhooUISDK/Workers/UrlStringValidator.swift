//
//  UrlValidator.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 02/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

protocol UrlStringValidatorProtocol {
    func isCorrectUrl(addrees: String) -> Bool
}

class UrlStringValidator: UrlStringValidatorProtocol {
    private let urlPrefix = "https://"

    func isCorrectUrl(addrees: String) -> Bool {
        return String(addrees.lowercased().prefix(urlPrefix.count)) == urlPrefix
    }
    
}
