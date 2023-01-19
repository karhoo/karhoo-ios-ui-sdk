//
//  KarhooMaterialDesignTextField.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 16/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct KarhooMaterialDesignTextField: View {
   
    @Binding var textFieldText: String
    @Binding var isTextfieldValid: Bool
    @State private var isFirstResponder: Bool = false

    var placeholder: String
    var errorMessage: String
    var contentType: KarhooTextInputViewContentType
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack{
                TextField(placeholder, text: $textFieldText, onEditingChanged: { (editingChanged) in
                    if editingChanged {
                        isFirstResponder = true
                    } else {
                        isFirstResponder = false
                    }
                })
                .onChange(of: textFieldText) { newValue in
                    withAnimation {
                        isTextfieldValid = getTextFieldValidity(newValue: newValue)
                    }
                }
                Button {
                    textFieldText = ""
                } label: {
                    Image(uiImage: .uisdkImage("kh_uisdk_cross_in_circle"))
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
    
    private func getTextFieldValidity(newValue: String) -> Bool {
        switch contentType {
        case .email:
            return Utils.isValidEmail(email: newValue)
        case .phone:
            return Utils.isValidPhoneNumber(number: newValue)
        case .firstname, .surname:
            return newValue != placeholder && Utils.isValidName(name: newValue)
        case .trainNumber, .flightNumber :
            return Utils.isAplhanumerical(newValue)
        default:
            return newValue != placeholder && newValue != ""
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
