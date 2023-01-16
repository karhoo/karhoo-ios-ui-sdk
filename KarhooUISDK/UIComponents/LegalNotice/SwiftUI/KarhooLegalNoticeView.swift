//
//  KarhooLegalNoticeView.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 15/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI
import Combine

struct KarhooLegalNoticeView: View {
    @StateObject var viewModel: KarhooLegalNoticeViewModel

    var body: some View {
        TextView($viewModel.text)
            .autoDetectDataTypes(.all)
            .isSelectable(true)
            .isEditable(false)
        )
    }
}
