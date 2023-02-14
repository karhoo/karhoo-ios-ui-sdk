//
//  KarhooMaterialDesignTextField.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 16/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct KarhooMaterialDesignTextField: View {
   
    @Binding var text: String
    @Binding var isTextfieldValid: Bool
    @State private var isFirstResponder: Bool = false

    var placeholder: String
    var errorMessage: String
    var contentType: KarhooTextInputViewContentType
    var textFieldValidator: TextFieldValidator = KarhooTextFieldValidator()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                TextField("", text: $text, onEditingChanged: { editingChanged in
                    if editingChanged {
                        isFirstResponder = true
                    } else {
                        isFirstResponder = false
                    }
                })
                .placeholder(placeholder, when: text.isEmpty)
                .foregroundColor(Color(KarhooUI.colors.text))
                .onChange(of: text) { newValue in
                    withAnimation {
                        isTextfieldValid = textFieldValidator.getTextFieldValidity(newValue, contentType: contentType)
                    }
                }
                Button {
                    text = ""
                } label: {
                    Image(uiImage: .uisdkImage("kh_uisdk_cross_in_circle"))
                        .resizable()
                        .frame(
                            width: UIConstants.Dimension.Icon.standard,
                            height: UIConstants.Dimension.Icon.standard
                        )
                }
            }
            .padding(.vertical, UIConstants.Spacing.medium)
            .padding(.leading, UIConstants.Spacing.standard)
            .padding(.trailing, UIConstants.Spacing.small)
            .addBorder(getBorderColor(), cornerRadius: UIConstants.CornerRadius.medium)
            
            if !isTextfieldValid {
                Text(errorMessage)
                    .font(Font(KarhooUI.fonts.footnoteSemiold()))
                    .foregroundColor(Color(KarhooUI.colors.error))
                    .padding(.top, UIConstants.Spacing.xSmall)
                    .transition(.opacity)
            }
        }
    }
    
    private func getBorderColor() -> Color {
        if !isTextfieldValid {
            return Color(KarhooUI.colors.error)
        } else if isFirstResponder {
            return Color(KarhooUI.colors.secondary)
        } else {
            return Color(KarhooUI.colors.border)
        }
    }
}
