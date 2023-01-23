//
//  KarhooBottomSheetContentWithTextFieldView.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 16/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct KarhooBottomSheetContentWithTextFieldView: View {
    
    @StateObject var viewModel: KarhooBottomSheetContentWithTextFieldViewModel
    var body: some View {
        VStack( alignment: .leading, spacing: 0) {
            Text(viewModel.viewSubtitle)
            KarhooMaterialDesignTextField(
                textFieldText: $viewModel.textFieldText,
                isTextfieldValid: $viewModel.isTextfieldValid,
                placeholder: viewModel.textFieldHint,
                errorMessage: viewModel.errorMessage,
                contentType: viewModel.contentType
            )
            .padding(.bottom, UIConstants.Spacing.standard)
            .padding(.top, UIConstants.Spacing.standard)
            KarhooMainButton(title: $viewModel.buttonText, isEnabled: $viewModel.isTextfieldValid) {
                viewModel.didTapSave(textFieldValue: viewModel.textFieldText)
            }
        }
    }
}

struct KarhooBottomSheetContentWithTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        KarhooBottomSheet(viewModel: KarhooBottomSheetViewModel(
            title: "Flight number") { }) {
                KarhooBottomSheetContentWithTextFieldView(viewModel: .init(
                    contentType: .flightNumber,
                    initialValueForTextField: "",
                    viewSubtitle: UITexts.Booking.flightSubtitle,
                    textFieldHint: UITexts.Booking.flightExample,
                    errorMessage: UITexts.Booking.onlyLettersAndDigitsAllowedError,
                    onSaveCallback: { newFlightNumber in return }
                )
            )
        }
    }
}
