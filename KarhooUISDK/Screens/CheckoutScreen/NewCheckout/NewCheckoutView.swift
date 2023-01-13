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

        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        dateView
                        addressView
                    }
                    .padding(.horizontal, UIConstants.Spacing.standard)
                    .background(Color(KarhooUI.colors.background2))
                    .padding(.bottom, UIConstants.Spacing.small)
                    
                    VehicleDetailsCard(
                        viewModel: viewModel.getVehicleDetailsCardViewModel()
                    )
                    VStack(spacing: UIConstants.Spacing.standard) {
                        DetailsCellView(viewModel: viewModel.passangerDetailsViewModel)
                        if viewModel.showFlightNumberCell {
                            DetailsCellView(viewModel: viewModel.flightNumberCellViewModel)
                        }
                        if viewModel.showTrainNumberCell {
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
            .onAppear {
                UIScrollView.appearance().bounces = false
            }
            .onDisappear {
                UIScrollView.appearance().bounces = true
            }
            priceView
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
        }
        .padding(.top, UIConstants.Spacing.standard)
        .background(Color(KarhooUI.colors.background2))
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
    
    @ViewBuilder
    private var priceView: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                Color(KarhooUI.colors.border)
                    .frame(height: UIConstants.Dimension.Border.standardWidth)
                HStack(alignment: .top, spacing: UIConstants.Spacing.standard) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(viewModel.quote.quoteType.description)
                            .font(Font(KarhooUI.fonts.captionBold()))
                            .foregroundColor(Color(KarhooUI.colors.textLabel))
                        HStack(spacing: UIConstants.Spacing.xSmall) {
                            Text(CurrencyCodeConverter.toPriceString(quote: viewModel.quote))
                                .font(Font(KarhooUI.fonts.title2Bold()))
                                .foregroundColor(Color(KarhooUI.colors.text))
                            Image(uiImage: .uisdkImage("kh_uisdk_help_circle")
                                .coloured(withTint: KarhooUI.colors.text)
                            )
                                .resizable()
                                .frame(
                                width: UIConstants.Dimension.Icon.medium,
                                height: UIConstants.Dimension.Icon.medium
                            )
                        }
                    }
                    .onTapGesture {
                        viewModel.showPriceDetails()
                    }
                    Spacer()
                    KarhooMainButton(title: viewModel.bottomButtonText) {
                        return
                    }
                    .frame(width: (geometry.size.width - 3 * UIConstants.Spacing.standard) * 0.4)
                }
                .padding(.all, UIConstants.Spacing.standard)
                .background(Color(KarhooUI.colors.background2).ignoresSafeArea())
            }
        }
    }
}
