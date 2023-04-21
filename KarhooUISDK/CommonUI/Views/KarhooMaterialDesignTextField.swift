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
    
    private var title: String {
        contentType.placeholderText
    }
    
    private var isTitleVisible: Bool {
        switch contentType {
        case .firstname, .surname, .email, .phone:
            return true
        default:
            return false
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
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
                    .font(Font(KarhooUI.fonts.bodyRegular()))
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
                
                if isTitleVisible {
                    Text(title)
                        .padding(
                            EdgeInsets(
                                top: 0,
                                leading: UIConstants.Spacing.xSmall,
                                bottom: 0,
                                trailing: UIConstants.Spacing.xSmall
                            )
                        )
                        .foregroundColor(getTitleColor())
                        .font(Font(KarhooUI.fonts.captionRegular()))
                        .background(Color(KarhooUI.colors.background2))
                        .offset(
                            x: UIConstants.Spacing.medium,
                            y: -KarhooUI.fonts.captionRegular().pointSize / 2
                        )
                }
            }
            
            if !isTextfieldValid {
                Text(errorMessage)
                    .font(Font(KarhooUI.fonts.footnoteRegular()))
                    .foregroundColor(Color(KarhooUI.colors.error))
                    .padding(.top, UIConstants.Spacing.xSmall)
                    .transition(.opacity)
                    .offset(
                        x: UIConstants.Spacing.standard
                    )
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
    
    private func getTitleColor() -> Color {
        if !isTextfieldValid {
            return Color(KarhooUI.colors.error)
        } else if isFirstResponder {
            return Color(KarhooUI.colors.secondary)
        } else {
            return Color(KarhooUI.colors.textLabel)
        }
    }
}

struct KarhooMaterialDesignTextField_Previews: PreviewProvider {
    static var previews: some View {
        KarhooMaterialDesignTextField(
            text: .constant("Some text"),
            isTextfieldValid: .constant(true),
            placeholder: "Some placeholder",
            errorMessage: "Nothing to add",
            contentType: .firstname
        )
    }
}
