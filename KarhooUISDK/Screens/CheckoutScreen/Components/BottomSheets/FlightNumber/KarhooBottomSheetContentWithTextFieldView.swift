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
        VStack( alignment: .leading, spacing: 0){
            Text(viewModel.viewSubtitle)
            KarhooNewTextField(
                textFieldText: $viewModel.textFieldText,
                isTextfieldValid: $viewModel.isTextfieldValid,
                hint: viewModel.textFieldHint,
                errorMessage: viewModel.errorMessage
            )
            .padding(.bottom, UIConstants.Spacing.standard)
            .padding(.top, UIConstants.Spacing.xLarge)
            KarhooMainButton(title: viewModel.buttonText) {
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
                    initialValueForTextField: "",
                    viewSubtitle: UITexts.Booking.flightSubtitle,
                    textFieldHint: UITexts.Booking.flightExcample,
                    errorMessage: UITexts.Booking.flightError,
                    onSaveCallback: {newFlightNumber in return }
                )
            )
        }
    }
}
