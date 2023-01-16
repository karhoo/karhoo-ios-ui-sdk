//
//  KarhooNewTextField.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 16/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI


struct KarhooNewTextField: View {
    @State private var borderColor: Color = Color(KarhooUI.colors.accent)
    @Binding var textFieldText: String
    var hint: String
    var body: some View {
        HStack {
            TextField(hint, text: $textFieldText, onEditingChanged: { (editingChanged) in
                if editingChanged {
                    print("TextField focused")
                } else {
                    print("TextField focus removed")
                }
            })
            Button{
                textFieldText = ""
            } label: {
                Image(uiImage: .uisdkImage("kh_uisdk_cross_in_circle"))
                    .frame(
                        width: UIConstants.Dimension.Icon.standard,
                        height:UIConstants.Dimension.Icon.standard
                    )
            }
        }
        .padding(.vertical, UIConstants.Spacing.medium)
        .padding(.leading, UIConstants.Spacing.standard)
        .padding(.trailing, UIConstants.Spacing.small)
        .addBorder(Color.red, cornerRadius: UIConstants.CornerRadius.medium)
    }
}
