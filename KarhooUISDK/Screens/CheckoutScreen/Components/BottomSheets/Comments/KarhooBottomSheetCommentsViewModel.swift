//
//  KarhooBottomSheetCommentsViewModel.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 18/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import SwiftUI

final class KarhooBottomSheetCommentsViewModel: ObservableObject {
    @Published var textViewText: String

    let initialValueForTextView: String
    let onSaveCallback: (_ newComment: String) -> Void

    let viewSubtitle: String
    let buttonText = UITexts.Generic.save
    
    init(
        initialValueForTextView: String,
        viewSubtitle: String,
        onSaveCallback: @escaping (_ newFlightNumber: String) -> Void
    ) {
        self.initialValueForTextView = initialValueForTextView
        self.viewSubtitle = viewSubtitle
        self.onSaveCallback = onSaveCallback
        textViewText = initialValueForTextView
    }
    
    func didTapSave(textFieldValue: String) {
        onSaveCallback(textFieldValue)
    }
}
