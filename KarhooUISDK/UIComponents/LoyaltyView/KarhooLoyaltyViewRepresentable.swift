//
//  KarhooLoyaltyViewRepresentable.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 17.01.2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import SwiftUI

struct SwiftUILoyaltyView: UIViewRepresentable {
    typealias UIViewType = KarhooLoyaltyView
    
    let viewModel: LoyaltyViewDataModel
    let quoteId: String
    let delegate: LoyaltyViewDelegate
    
    func makeUIView(context: Context) -> KarhooLoyaltyView {
        let view = KarhooLoyaltyView()
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        return view
    }
    
    func updateUIView(_ uiView: KarhooLoyaltyView, context: Context) {
        uiView.set(dataModel: viewModel, quoteId: quoteId)
        uiView.delegate = delegate
    }
}
