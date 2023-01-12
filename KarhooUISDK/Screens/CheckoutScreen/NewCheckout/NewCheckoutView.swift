//
//  NewCheckoutView.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 05/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct NewCheckoutView: View {

    enum Constants {
        static let addressViewHeight: CGFloat = 100
    }
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: KarhooNewCheckoutViewModel

    var body: some View {
        VStack(spacing: 0) {
            dateView
            addressView
            KarhooMainButton(title: "Test") {
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .onAppear {
            viewModel.onAppear()
        }
        .alert(isPresented: $viewModel.quoteExpired) {
            quoteExpiredAlert
        }
    }

    @ViewBuilder
    private var dateView: some View {
        HStack(spacing: 0) {
            Text(viewModel.getDateScheduledDescription())
                .foregroundColor(Color(KarhooUI.colors.text))
                .font(Font(KarhooUI.fonts.headerBold()))
                .frame(maxWidth: .infinity)
                .fixedSize()
            Spacer()
        }.padding(.top, UIConstants.Spacing.standard)
    }

    @ViewBuilder
    private var addressView: some View {
        KarhooAddressView(
            pickUp: .init(
                text: viewModel.getPrintedPickUpAddressLine1(),
                subtext: viewModel.getPrintedPickUpAddressLine2()
            ),
            destination: .init(
                text: viewModel.getPrintedDropOffAddressLine1(),
                subtext: viewModel.getPrintedDropOffAddressLine2()
            ),
            design: .borderlessWithoutBackground,
            showsLineBetweenPickUpAndDestination: true,
            timeLabelText: viewModel.getTimeLabelTextDescription()
        )
    }

    private var quoteExpiredAlert: Alert {
        Alert(
            title: Text(UITexts.Booking.quoteExpiredTitle),
            message: Text(UITexts.Booking.quoteExpiredMessage),
            dismissButton: .default(Text(UITexts.Generic.ok)) {
                presentationMode.wrappedValue.dismiss()
            }
        )
    }
}
