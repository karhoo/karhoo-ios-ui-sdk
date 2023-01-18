//
//  KarhooBottomSheetCommentsView.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 18/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct KarhooBottomSheetCommentsView: View {
    
    @StateObject var viewModel: KarhooBottomSheetCommentsViewModel

    var body: some View {
        VStack( alignment: .leading, spacing: 0) {
            Text(viewModel.viewSubtitle)
                .padding(.bottom, UIConstants.Spacing.xLarge)
            TextView($viewModel.textViewText)
                .frame(minHeight: 50)
                .padding(.horizontal, UIConstants.Spacing.standard)
                .padding(.vertical, UIConstants.Spacing.medium)
                .addBorder(
                    Color(KarhooUI.colors.secondary),
                    cornerRadius: UIConstants.CornerRadius.medium
                )
                .padding(.bottom, UIConstants.Spacing.large)
            KarhooMainButton(title: viewModel.buttonText) {
                viewModel.didTapSave(textFieldValue: viewModel.textViewText)
            }
        }
    }
}

struct KarhooBottomSheetCommentsView_Previews: PreviewProvider {
    static var previews: some View {
        
        KarhooBottomSheet(
            viewModel: KarhooBottomSheetViewModel(
                title: UITexts.Booking.commentsTitle,
                onDismissCallback: { return })){
                KarhooBottomSheetCommentsView(
                    viewModel: KarhooBottomSheetCommentsViewModel(
                        initialValueForTextView: "first \n second \n third \n 4th",
                        viewSubtitle: UITexts.Booking.commentsSubtitle,
                        onSaveCallback: { _ in return }
                    )
                )
            }
    }
}

