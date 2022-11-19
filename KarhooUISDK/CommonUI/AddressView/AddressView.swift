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

    let pickUp: AddressLabel
    let destination: AddressLabel
    let timeLabelText: String?
    let tags: [Tag]
    var borderColor: UIColor = KarhooUI.colors.border
    let borderWidth: CGFloat = 1
    var cornerRadius: CGFloat = UIConstants.CornerRadius.large
    var backgroundColor: UIColor = KarhooUI.colors.white
    let showsLineBetweenPickUpAndDestination: Bool

    // MARK: - Lifecycle

    init(
        pickUp: AddressLabel,
        destination: AddressLabel,
        design: Design = .default,
        showsLineBetweenPickUpAndDestination: Bool = true,
        timeLabelText: String? = nil,
        tags: [Tag] = []
    ) {
        self.pickUp = pickUp
        self.destination = destination
        self.borderColor = design.borderColor
        self.backgroundColor = design.backgroundColor
        self.timeLabelText = timeLabelText
        self.tags = tags
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
            AddressLabelView(
                text: pickUp.text,
                subtext: pickUp.subtext
            )
            if tags.isNotEmpty {
                buildTagsView()
            } else {
                Spacer(minLength: UIConstants.Spacing.medium)
            }
            AddressLabelView(
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
                .padding(.top, UIConstants.Dimension.View.addressViewPadding)
                .minimumScaleFactor(UIConstants.Dimension.View.addressViewMinimumScaleFactor)
            Spacer()
        }
    }

    @ViewBuilder
    private func buildTagsView() -> some View {
        VStack(alignment: .leading) {
            ForEach(tags) {
                TagView(tag: $0)
            }
        }
        .padding(.vertical, UIConstants.Spacing.xSmall)
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

// MARK: - Address label model & view
extension KarhooAddressView {

    struct AddressLabel {
        let text: String
        let subtext: String
    }

    struct AddressLabelView: View {

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
}

// MARK: - Tag model & view
extension KarhooAddressView {
    struct Tag: Identifiable {
        let id = UUID()
        let title: String
    }

    struct TagView: View {

        let tag: Tag

        var body: some View {
            Text(tag.title)
                .font(Font(KarhooUI.fonts.captionBold()))
                .frame(height: 14)
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(Color(KarhooUI.colors.primary))
                .foregroundColor(Color(KarhooUI.colors.background2))
                .addBorder(.clear, cornerRadius: 5)
        }
    }
}
