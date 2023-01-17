//
//  KarhooNewTextField.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 16/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct KarhooNewTextField: View {
   
    @Binding var textFieldText: String
    @Binding var isTextfieldValid: Bool
    
    var hint: String
    var errorMessage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack{
                TextField(hint, text: $textFieldText, onEditingChanged: { (editingChanged) in
                    if editingChanged {
                        print("TextField focused")
                    } else {
                        print("TextField focus removed")
                    }
                })
                .onChange(of: textFieldText) { newValue in
                    withAnimation {
                        validateTextField(newValue: newValue)
                    }
                }
                Button {
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
            .addBorder(
                isTextfieldValid ? Color(KarhooUI.colors.secondary) : Color(KarhooUI.colors.error),
                cornerRadius: UIConstants.CornerRadius.medium
            )
            
            if !isTextfieldValid {
                Text(errorMessage)
                    .font(Font(KarhooUI.fonts.footnoteSemiold()))
                    .foregroundColor(Color(KarhooUI.colors.error))
                    .padding(.top, UIConstants.Spacing.xSmall)
                    .transition(.opacity)
            }
        }
    }
    
    private func validateTextField(newValue: String) {
        var isValid: Bool {
            for char in newValue {
                if !char.isLetter && !char.isNumber {
                    return false
                }
            }
            return true
        }
        isTextfieldValid = isValid
    }
}
