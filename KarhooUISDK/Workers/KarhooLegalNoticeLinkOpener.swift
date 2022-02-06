//
//  KarhooLegalNoticeLinkOpener.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 02/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit

final class KarhooLegalNoticeLinkOpener {
    private let linkParser: LinkParserProtocol
    private weak var viewControllerToPresentFrom: UIViewController?
    
    init(linkParser: LinkParserProtocol = LinkParser(), viewControllerToPresentFrom: UIViewController?) {
        self.linkParser = linkParser
        self.viewControllerToPresentFrom = viewControllerToPresentFrom
    }
    
    @discardableResult func openLink(link: String) -> Bool{
        guard let linkType = linkParser.getLinkType(link) else {
            assertionFailure("Try to open incorrect link format in KarhooLegalNoticeLinkOpener")
            return false
        }
        switch linkType {
        case .url(let url):
            if UIApplication.shared.canOpenURL(url){
                UIApplication.shared.open(url)
                return true
            } else {
                return false
            }
        case .mail(let addrees):
            _ = KarhooLegalNoticeMailComposer(parent: viewControllerToPresentFrom).sendLegalNoticeMail(addrees: addrees)
            return true
        }
    }
}
