//
//  LegalNoticePresenter.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 10/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

protocol LegalNoticePresenter {
    var shouldShowView: Bool { get }
    func openLink(link: String, handler: BaseViewController)
}

class KarhooLegalNoticePresenter: LegalNoticePresenter {
    let shouldShowView: Bool = true //UITexts.Booking.legalNoticeText.isNotEmpty
    
    func openLink(link: String, handler: BaseViewController) {
        KarhooLegalNoticeLinkOpener(viewControllerToPresentFrom: handler).openLink(link: link)
    }
}
