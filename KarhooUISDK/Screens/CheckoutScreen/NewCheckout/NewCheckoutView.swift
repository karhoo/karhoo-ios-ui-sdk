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
    @StateObject var viewModel: KarhooNewCheckoutViewModel

    var body: some View {

        ScrollView {
            VStack(spacing: 0) {
                VStack(spacing: 0){
                    dateView
                    addressView
                }
                .padding(.horizontal, UIConstants.Spacing.standard)
                .background(KarhooUI.colors.background2.getColor())
                .padding(.bottom, UIConstants.Spacing.small)
                
                VehicleDetailsCard(
                    viewModel: viewModel.getVehicleDetailsCardViewModel()
                )
                VStack(spacing:UIConstants.Spacing.standard) {
                    DetailsCellView(viewModel: viewModel.passangerDetailsViewModel)
                    if (viewModel.showFlightNumberCell) {
                        DetailsCellView(viewModel: viewModel.flightNumberCellViewModel)
                    }
                    if (viewModel.showTrainNumberCell) {
                        DetailsCellView(viewModel: viewModel.trainNumberCellViewModel)
                    }
                    DetailsCellView(viewModel: viewModel.commentCellViewModel)
                    
                }
                .padding(.top, UIConstants.Spacing.standard)
                .padding(.horizontal, UIConstants.Spacing.standard)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
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
        .background(KarhooUI.colors.background2.getColor())
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
}
