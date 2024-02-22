//
//  KarhooLegalNoticeViewModel.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 16/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Combine
import SwiftUI

final class KarhooLegalNoticeViewModel: ObservableObject {

    @Published var shouldShowView: Bool
    @Published var text: NSAttributedString

    init(
        shouldShow: Bool = UITexts.Booking.legalNoticeText.isNotEmpty,
        text: NSAttributedString = LegalNoticeStringBuilder().getLegalNotice()
    ) {
        self.shouldShowView = shouldShow
        self.text = text
    }
}
