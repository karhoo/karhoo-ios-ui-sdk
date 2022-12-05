//
//  AddToCalendarView.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 25/11/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

/// View Presenting add-to-calendar option. It does not have any actual logic implemented. To add event to the calendar, please handle `viewModel.onAddAction` and use `AddToCalendarWorker`.
/// If succeeded, set `viewModel.state` to `.added`, to change design from button, to success information label.
struct KarhooAddToCalendarView: View {

    // MARK: - Nested types

    private enum Constants {
        static let height: CGFloat = 28
        static let calendarIconSide: CGFloat = 20
    }
    enum State: String, Hashable {
        case add
        case added
    }

    // MARK: - Properties

    @ObservedObject var viewModel: ViewModel

    // MARK: - Views

    var body: some View {
        buildContent(for: $viewModel.state.wrappedValue)
    }

    private func buildContent(for state: State) -> some View {
        switch state {
        case .add:
            return AnyView(viewForAddState)
        case .added:
            return AnyView(viewForAddedState)
        }
    }

    @ViewBuilder
    private var viewForAddState: some View {
        Button(
            action: {
                viewModel.addTapped()
            },
            label: {
                HStack(spacing: UIConstants.Spacing.small) {
                    Image(uiImage: UIImage.uisdkImage("kh_uisdk_calendar"))
                        .resizable()
                        .frame(
                            width: Constants.calendarIconSide,
                            height: Constants.calendarIconSide
                        )
                        .foregroundColor(Color(KarhooUI.colors.accent))
                    Text(UITexts.TripSummary.addToCalendar)
                        .font(Font(KarhooUI.fonts.bodyBold()))
                        .foregroundColor(Color(KarhooUI.colors.accent))
                }
                .frame(height: Constants.height)
            }
        )
    }

    @ViewBuilder
    private var viewForAddedState: some View {
        HStack(spacing: 8) {
            Image(uiImage: UIImage.uisdkImage("kh_uisdk_trip_completed"))
                .resizable()
                .frame(
                    width: UIConstants.Dimension.Icon.medium,
                    height: UIConstants.Dimension.Icon.medium
                )
                .foregroundColor(Color(KarhooUI.colors.white))
            Text(UITexts.TripSummary.addedToCalendar)
                .font(Font(KarhooUI.fonts.captionBold()))
                .foregroundColor(Color(KarhooUI.colors.white))
        }
            .padding()
            .frame(height: Constants.height)
            .background(Color(KarhooUI.colors.success))
            .cornerRadius(UIConstants.CornerRadius.medium)
    }
}
