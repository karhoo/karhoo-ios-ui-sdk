//
//  CheckoutView.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 05/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct CheckoutView: View {

    enum Constants {
        static let addressViewHeight: CGFloat = 100
        static let bottomPadding: CGFloat = 80
        static let legalNoticeViewId = "legalNoticeViewId"
        static let termsConditionsViewId = "termsConditionsViewId"
    }
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: KarhooCheckoutViewModel

    var body: some View {
        ZStack {
            contentView
            priceView
            if viewModel.state == .loading {
                loadingOverlay
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            viewModel.onAppear()
        }
        
        .alert(isPresented: $viewModel.showError) {
            if viewModel.quoteExpired {
                return quoteExpiredAlert
            } else {
                return errorAlert
            }
        }
    }

    /// The view main content without bottom price & button stack
    @ViewBuilder
    private var contentView: some View {
        ScrollViewReader { scrollViewProxy in
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
                    if viewModel.loyaltyViewModel.shouldShowView {
                        LoyaltyView(viewModel: viewModel.loyaltyViewModel)
                            .padding(.horizontal, UIConstants.Spacing.standard)
                    }
                    
                    VStack(spacing: UIConstants.Spacing.standard) {
                        
                        DetailsCellView(viewModel: viewModel.passangerDetailsViewModel)

                        if viewModel.showFlightNumberCell {
                            DetailsCellView(viewModel: viewModel.flightNumberCellViewModel)
                        }
                        if viewModel.showTrainNumberCell {
                            DetailsCellView(viewModel: viewModel.trainNumberCellViewModel)
                        }
                        DetailsCellView(viewModel: viewModel.commentCellViewModel)

                        KarhooTermsConditionsView(viewModel: viewModel.termsConditionsViewModel)
                            .padding(.vertical, UIConstants.Spacing.large)
                            .id(Constants.termsConditionsViewId)

                        // Legal Notice button
                        if viewModel.legalNoticeViewModel.shouldShowView {
                            HStack {
                                Spacer()
                                Text(UITexts.Booking.legalNotice)
                                    .foregroundColor(Color(KarhooUI.colors.accent))
                                    .font(Font(KarhooUI.fonts.captionSemibold()))
                                    .multilineTextAlignment(.trailing)
                            }
                            KarhooLegalNoticeView(viewModel: viewModel.legalNoticeViewModel)
                        }
                        Spacer()
                    }
                    .padding(.top, UIConstants.Spacing.standard)
                    .padding(.horizontal, UIConstants.Spacing.standard)

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .id(Constants.legalNoticeViewId)
                .onChange(of: viewModel.scrollToTermsConditions) { scrollToTermsConditions in
                    if scrollToTermsConditions {
                        withAnimation {
                            scrollViewProxy.scrollTo(Constants.termsConditionsViewId, anchor: .bottom)
                        }
                    }
                }
            }
            .padding(.bottom, Constants.bottomPadding)
            .onAppear {
                UIScrollView.appearance().bounces = false
            }
            .onDisappear {
                UIScrollView.appearance().bounces = true
            }
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
                            .font(Font(KarhooUI.fonts.captionSemibold()))
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
                    KarhooMainButton(title: $viewModel.confirmButtonTitle) {
                        viewModel.didTapConfirm()
                    }
                    .frame(width: (geometry.size.width - 3 * UIConstants.Spacing.standard) * 0.4)
                }
                .padding(.all, UIConstants.Spacing.standard)
                .background(Color(KarhooUI.colors.background2).ignoresSafeArea())
            }
        }
    }

    @ViewBuilder
    private var loadingOverlay: some View {
        Color(KarhooUI.colors.background2.withAlphaComponent(0.4))
            .overlay(
                ProgressView()
                    .progressViewStyle(.circular)
                    .foregroundColor(Color(KarhooUI.colors.primary)),
                alignment: .center
            )
    }

    // MARK: - Helpers

    private var quoteExpiredAlert: Alert {
        Alert(
            title: Text(UITexts.Booking.quoteExpiredTitle),
            message: Text(UITexts.Booking.quoteExpiredMessage),
            dismissButton: .default(Text(UITexts.Generic.ok)) {
                presentationMode.wrappedValue.dismiss()
            }
        )
    }

    private var errorAlert: Alert {
        let errorMessage = viewModel.errorToPresent?.message != nil ? Text(viewModel.errorToPresent!.message!) : nil
        return Alert(
            title: Text(viewModel.errorToPresent?.title ?? UITexts.Generic.error),
            message: errorMessage,
            dismissButton: .default(Text(UITexts.Generic.ok))
        )
    }
}
