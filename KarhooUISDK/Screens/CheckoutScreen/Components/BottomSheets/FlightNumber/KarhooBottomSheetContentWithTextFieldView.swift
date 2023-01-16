//
//  KarhooBottomSheetContentWithTextFieldView.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 16/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct KarhooBottomSheetContentWithTextFieldView: View {
    
    init(viewModel: KarhooBottomSheetContentWithTextFieldViewModel){
        self.viewModel = viewModel
        _textFieldText = State(initialValue: viewModel.initialValueForTextField)
    }
    private var viewModel: KarhooBottomSheetContentWithTextFieldViewModel
    @State private var textFieldText: String
    var body: some View {
        VStack( alignment: .leading, spacing: 0){
            Text(viewModel.viewSubtitle)
            TextField(viewModel.textFieldHint, text: $textFieldText)
            
            KarhooMainButton(title: viewModel.buttonText) {
                viewModel.didTapSave(textFieldValue: textFieldText)
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
                    onSaveCallback: {newFlightNumber in return }
                )
                )
        }
    }
}
