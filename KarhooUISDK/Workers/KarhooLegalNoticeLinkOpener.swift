//
//  KarhooLegalNoticeLinkOpener.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 02/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit

protocol LegalNoticeLinkOpener: AnyObject {
    func openLink(link: String)
}

final class KarhooLegalNoticeLinkOpener: LegalNoticeLinkOpener {
    private let linkParser: LinkParserProtocol
    private weak var viewControllerToPresentFrom: BaseViewController?
    
    init(linkParser: LinkParserProtocol = LinkParser(), viewControllerToPresentFrom: BaseViewController?) {
        self.linkParser = linkParser
        self.viewControllerToPresentFrom = viewControllerToPresentFrom
    }
    
    func openLink(link: String) {
        guard let linkType = linkParser.getLinkType(link) else {
            assertionFailure("Try to open incorrect link format in KarhooLegalNoticeLinkOpener")
            return
        }
        switch linkType {
        case .url(let url):
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        case .mail(let addrees):
            _ = KarhooLegalNoticeMailComposer(parent: viewControllerToPresentFrom).sendLegalNoticeMail(addrees: addrees)
        }
    }
}
