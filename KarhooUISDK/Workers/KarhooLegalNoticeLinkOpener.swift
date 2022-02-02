//
//  KarhooLegalNoticeLinkOpener.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 02/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit

class KarhooLegalNoticeLinkOpener {
    let linkParser: LinkParserProtocol
    private weak var viewControllerToPresentFrom: UIViewController?
    
    init(linkParser: LinkParserProtocol = LinkParser(), viewControllerToPresentFrom: UIViewController?) {
        self.linkParser = linkParser
        self.viewControllerToPresentFrom = viewControllerToPresentFrom
    }
    
    func openLink(link: String) {
        guard let linkType = linkParser.getLinkType(link) else { return }
        switch linkType {
        case .url(let url):
            if UIApplication.shared.canOpenURL(url){
                UIApplication.shared.open(url)
            }
        case .mail(let addrees):
            _ = KarhooLegalNoticeMailComposer(parent: viewControllerToPresentFrom).sendLegalNoticeMail(addrees: addrees)
        }
    }
}
