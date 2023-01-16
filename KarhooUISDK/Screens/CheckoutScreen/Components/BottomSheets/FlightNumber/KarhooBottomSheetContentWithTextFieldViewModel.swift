//
//  KarhooBottomSheetContentWithTextFieldViewModel.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 16/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import SwiftUI

final class KarhooBottomSheetContentWithTextFieldViewModel {
    var initialValueForTextField: String
    var onSaveCallback: (_ newFlightNumber: String) -> Void

    let viewSubtitle: String
    let buttonText = UITexts.Generic.save
    let textFieldHint: String
    
    init(
        initialValueForTextField: String,
        viewSubtitle: String,
        textFieldHint: String,
        onSaveCallback:  @escaping (_ newFlightNumber: String) -> Void
    ) {
        self.initialValueForTextField = initialValueForTextField
        self.viewSubtitle = viewSubtitle
        self.textFieldHint = textFieldHint
        self.onSaveCallback = onSaveCallback
    }
    
    func didTapSave(textFieldValue: String){
        onSaveCallback(textFieldValue)
    }
}
