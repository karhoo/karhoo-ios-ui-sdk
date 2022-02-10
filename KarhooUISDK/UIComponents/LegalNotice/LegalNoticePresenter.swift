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
}

class KarhooLegalNoticePresenter: LegalNoticePresenter {
    let shouldShowView: Bool = UITexts.Booking.legalNoticeText.isNotEmpty
}



