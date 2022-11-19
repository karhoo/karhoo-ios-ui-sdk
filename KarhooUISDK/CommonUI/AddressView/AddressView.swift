//
//  AddressView.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 16/11/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import SwiftUI

/// New Address view. Shows pick up, destination and places in between (if needed). View does not provide interactions by default.
struct KarhooAddressView: View {

    // MARK: - Nested types

    struct Label {
        let text: String
        let subtext: String
    }

    enum Design {
        /// Bordered view, with SDKs `background1` color and rounded corners.
        case bordered
        /// Bordered view, with SDKs `white` color and rounded corners.
        case borderedWithWhiteBackground
        /// Bordereless view with `white` color from SDK palette.
        case `default`

        var backgroundColor: UIColor {
            switch self {
            case .bordered:
                return KarhooUI.colors.background1
            case .borderedWithWhiteBackground, .default:
                return KarhooUI.colors.white
            }
        }

        var borderColor: UIColor {
            switch self {
            case .bordered, .borderedWithWhiteBackground:
                return KarhooUI.colors.border
            case .default:
                return KarhooUI.colors.white
            }
        }
    }

    // MARK: - Properties

    let pickUp: Label
    let destination: Label
    let timeLabelText: String?
    var borderColor: UIColor = KarhooUI.colors.border
    let borderWidth: CGFloat = 1
    var cornerRadius: CGFloat = UIConstants.CornerRadius.large
    var backgroundColor: UIColor = KarhooUI.colors.white
    let showsLineBetweenPickUpAndDestination: Bool

    // MARK: - Lifecycle

    init(
        pickUp: Label,
        destination: Label,
        design: Design = .default,
        showsLineBetweenPickUpAndDestination: Bool = true,
        timeLabelText: String? = nil
    ) {
        self.pickUp = pickUp
        self.destination = destination
        self.borderColor = design.borderColor
        self.backgroundColor = design.backgroundColor
        self.timeLabelText = timeLabelText
        self.showsLineBetweenPickUpAndDestination = showsLineBetweenPickUpAndDestination
    }

    // MARK: - Views

    var body: some View {
        HStack(spacing: UIConstants.Spacing.medium) {
            dotsColumn
            labelsColumn
            HStack(alignment: .top, spacing: 0) {
                if let text = timeLabelText {
                    buildTimeTextView(text)
                } else {
                    EmptyView()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(UIConstants.Spacing.medium)
        .background(Color(backgroundColor))
        .addBorder(Color(borderColor), cornerRadius: cornerRadius)
        .colorScheme(.light)
    }

    @ViewBuilder
    private var dotsColumn: some View {
        VStack(spacing: UIConstants.Spacing.xSmall) {
            Spacer()
            Image("kh_uisdk_empty_circle_secondary", bundle: .current)
                .frame(
                    width: UIConstants.Dimension.View.addressViewRoundIconSide,
                    height: UIConstants.Dimension.View.addressViewRoundIconSide
                )
            if showsLineBetweenPickUpAndDestination {
                VLine()
                    .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [4, 5]))
                    .frame(width: 2)
                    .foregroundColor(Color(KarhooUI.colors.border))
            } else {
                Spacer()
            }

            Image("kh_uisdk_empty_circle_primary", bundle: .current)
                .frame(
                    width: UIConstants.Dimension.View.addressViewRoundIconSide,
                    height: UIConstants.Dimension.View.addressViewRoundIconSide
                )
            Spacer()
        }
    }

    @ViewBuilder
    private var labelsColumn: some View {
        VStack(alignment: .leading) {
            AddressLabel(
                text: pickUp.text,
                subtext: pickUp.subtext
            )
            Spacer(minLength: UIConstants.Spacing.medium)
            AddressLabel(
                text: destination.text,
                subtext: destination.subtext
            )
        }
    }

    @ViewBuilder
    private func buildTimeTextView(_ text: String) -> some View {
        VStack {
            Text(text)
                .font(Font(KarhooUI.fonts.captionBold()))
                .multilineTextAlignment(.trailing)
                .padding(.top, UIConstants.Dimension.View.addressViewTimeLabelTopPadding)
                .minimumScaleFactor(UIConstants.Dimension.View.addressViewMinimumScaleFactor)
            Spacer()
        }
    }
}

struct KarhooAddressView_Preview: PreviewProvider {
    static var previews: some View {
        KarhooAddressView(
            pickUp: .init(text: "London City Airport, Hartmann Rd", subtext: "London E16 2PX, United Kingdom"),
            destination: .init(text: "10 downing st westminster", subtext: "London SW1A 2AA, United Kingdom")
        )
    }
}

private struct AddressLabel: View {

    let text: String
    var subtext: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(text)
                .font(Font(KarhooUI.fonts.bodyRegular()))
                .lineLimit(1)
                .minimumScaleFactor(UIConstants.Dimension.View.addressViewMinimumScaleFactor)
                .foregroundColor(Color(KarhooUI.colors.text))
                .frame(maxWidth: .infinity, alignment: .leading)
            if let subtext = subtext {
                Text(subtext)
                    .font(Font(KarhooUI.fonts.captionBold()))
                    .lineLimit(1)
                    .minimumScaleFactor(UIConstants.Dimension.View.addressViewMinimumScaleFactor)
                    .foregroundColor(Color(KarhooUI.colors.textLabel))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(height: UIConstants.Dimension.View.addressViewLabelHeight)
    }
}
