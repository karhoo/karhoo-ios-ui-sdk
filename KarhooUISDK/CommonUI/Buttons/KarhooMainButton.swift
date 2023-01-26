//
//  KarhooMainButton.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct KarhooMainButton: View {
    @Binding var title: String
    @Binding var isEnabled: Bool
    @State var callback: () -> Void

    init(
        title: Binding<String>,
        isEnabled: Binding<Bool> = Binding.constant(true),
        callback: @escaping () -> Void
    ) {
        self._title = title
        self._isEnabled = isEnabled
        self.callback = callback
    }

    var body: some View {
        Button(
            action: {
                callback()
            },
            label: {
                Text(title)
                .padding(.horizontal, UIConstants.Spacing.standard)
                .font(Font(KarhooUI.fonts.headerBold()))
                .minimumScaleFactor(0.7)
                .foregroundColor(Color(KarhooUI.colors.white))
                .frame(maxWidth: .infinity)
                .frame(height: UIConstants.Dimension.Button.mainActionButtonHeight)
                .background(isEnabled ? Color(KarhooUI.colors.secondary) : Color(KarhooUI.colors.inactive))
                .addBorder(.clear, cornerRadius: UIConstants.CornerRadius.medium)
            }
        )
        .disabled(!isEnabled)
    }
}

struct KarhooMainButton_preview: PreviewProvider {
    static var previews: some View {
        KarhooMainButton(title: .constant("Sample Title"), isEnabled: .constant(true), callback: {})
    }
}
