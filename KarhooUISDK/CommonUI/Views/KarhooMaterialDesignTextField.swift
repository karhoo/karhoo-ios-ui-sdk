//
//  KarhooMaterialDesignTextField.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 16/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI
import Combine

struct KarhooMaterialDesignTextField: View {
   
    @Binding var text: String
    @Binding var isTextfieldValid: Bool
    @State private var isFirstResponder: Bool = false
    
    /// Sends back the current input type so that the main view can decide what the next input field is
    var onSubmitSubject = PassthroughSubject<KarhooTextInputViewContentType, Never>()

    var isMandatory: Bool = false
    var placeholder: String?
    var errorMessage: String
    var contentType: KarhooTextInputViewContentType
    var textFieldValidator: TextFieldValidator = KarhooTextFieldValidator()
    
    private var title: String {
        isMandatory ? "\(contentType.title)*" : contentType.title
    }
    
    private var accessibilityTitle: String {
        isMandatory ? "\(contentType.title), \(UITexts.Generic.mandatoryField)" : contentType.title
    }

    private var mainPlaceholder: String {
        guard let placeholder else {
            return contentType.placeholder
        }
        
        return placeholder
    }
    
    // Once min version is bumped to iOS 15, add specific keyboard type for .flightNumber
    private var contentInputType: UITextContentType {
        switch contentType {
        case .firstname:
            return .givenName
        case .surname:
            return .familyName
        case .email:
            return .emailAddress
        case .phone:
            return .telephoneNumber
        case .poiDetails:
            return .location
        default:
            return .name
        }
    }
    
    private var keyboardType: UIKeyboardType {
        switch contentType {
        case .email:
            return .emailAddress
        case .phone:
            return .phonePad
        default:
            return .alphabet
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                HStack {
                    TextField(
                        "",
                        text: $text,
                        onEditingChanged: { editingChanged in
                        if editingChanged {
                            isFirstResponder = true
                        } else {
                            isFirstResponder = false
                        }
                    }, onCommit: {
                        self.onSubmitSubject.send(contentType)
                    })
                    .placeholder(mainPlaceholder, when: text.isEmpty)
                    .foregroundColor(Color(KarhooUI.colors.text))
                    .font(Font(KarhooUI.fonts.bodyRegular()))
                    .keyboardType(keyboardType)
                    .textContentType(contentInputType)
                    .disableAutocorrection(true)
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
                .addBorder(
                    getBorderColor(),
                    width: UIConstants.Dimension.Border.xLargeWidth,
                    cornerRadius: UIConstants.CornerRadius.medium
                )
                
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
            .accessibilityElement()
            .accessibilityValue(Text(accessibilityTitle))
            
            if !isTextfieldValid {
                Text(errorMessage)
                    .font(Font(KarhooUI.fonts.footnoteRegular()))
                    .foregroundColor(Color(KarhooUI.colors.error))
                    .padding(.top, UIConstants.Spacing.xSmall)
                    .transition(.opacity)
                    .offset(
                        x: UIConstants.Spacing.standard
                    )
                    .accessibilityElement()
                    .accessibilityLabel(Text(errorMessage))
            }
            
            if isTextfieldValid && isMandatory {
                Text(UITexts.Generic.mandatoryField)
                    .font(Font(KarhooUI.fonts.footnoteRegular()))
                    .foregroundColor(Color(KarhooUI.colors.textLabel))
                    .padding(.top, UIConstants.Spacing.xSmall)
                    .transition(.opacity)
                    .offset(
                        x: UIConstants.Spacing.standard
                    )
                    .accessibilityElement()
                    .accessibilityValue(UITexts.Generic.mandatoryField)
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
            text: .constant(""),
            isTextfieldValid: .constant(true),
            isMandatory: true,
            errorMessage: "Some error",
            contentType: .firstname
        )
    }
}
