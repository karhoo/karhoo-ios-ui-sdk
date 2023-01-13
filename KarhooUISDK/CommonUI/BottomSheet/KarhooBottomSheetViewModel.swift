//
//  BottomSheetMPV.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 03.11.2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import SwiftUI

protocol BottomSheetViewModel {
    var title: String { get set }
    var cornerRadius: CGFloat { get set }
    var backgroundColor: Color { get set }
    
    func dismiss()
}

class KarhooBottomSheetViewModel: BottomSheetViewModel {
    var title: String = ""
    var backgroundColor: Color
    var cornerRadius: CGFloat
    private var onDismissCallback: () -> Void
    
    init(
        title: String,
        backgroundColor: Color = Color(KarhooUI.colors.background2),
        cornerRadius: CGFloat = UIConstants.CornerRadius.xxLarge,
        onDismissCallback: @escaping () -> Void
    ) {
            self.title = title
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.onDismissCallback = onDismissCallback
    }
    
    func dismiss() {
        onDismissCallback()
    }
}
