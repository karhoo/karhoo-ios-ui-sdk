//
//  KarhooBottomSheetContentWithTextFieldViewModel.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 16/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//
//  swiftlint:disable type_name

import Foundation
import SwiftUI

final class KarhooBottomSheetContentWithTextFieldViewModel: ObservableObject {
    @Published var textFieldText: String
    @Published var isTextfieldValid: Bool
    
    let contentType: KarhooTextInputViewContentType
    let initialValueForTextField: String
    let errorMessage: String
    let onSaveCallback: (_ newFlightNumber: String) -> Void

    let viewSubtitle: String
    var buttonText = UITexts.Generic.save
    let textFieldHint: String
    
    init(
        contentType: KarhooTextInputViewContentType,
        initialValueForTextField: String,
        viewSubtitle: String,
        textFieldHint: String,
        errorMessage: String,
        onSaveCallback: @escaping (_ newFlightNumber: String) -> Void
    ) {
        self.contentType = contentType
        self.initialValueForTextField = initialValueForTextField
        self.viewSubtitle = viewSubtitle
        self.textFieldHint = textFieldHint
        self.onSaveCallback = onSaveCallback
        self.errorMessage = errorMessage
        textFieldText = initialValueForTextField
        isTextfieldValid = true
    }
    
    func didTapSave(textFieldValue: String) {
        onSaveCallback(textFieldValue)
    }
}

//  swiftlint:enable type_name
