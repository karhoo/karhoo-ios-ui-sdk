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

    private enum Constants {
        static var maxWidth: CGFloat { UIScreen.main.bounds.width - UIConstants.Spacing.standard * 2 }
        static let dotsColumnWidth: CGFloat = 10
        static let labelHeight: CGFloat = 32
        static let padding: CGFloat = 10
        static let roundIconSide: CGFloat = 10
        static let minimumScaleFactor: CGFloat = 0.7
        static let timeLabelTextTopPadding: CGFloat = 20
    }

    enum Design {
        /// Bordered view, with SDKs `background1` color and rounded corners.
        case bordered
        /// Bordered view, with SDKs `white` color and rounded corners.
        case borderedWithWhiteBackground
        /// Bordereless view with `white` color from SDK palette.
        case borderlessWithWhiteBackground
        /// Bordereless view with `.clear` color.
        case borderlessWithoutBackground

        var backgroundColor: UIColor {
            switch self {
            case .bordered:
                return KarhooUI.colors.background1
            case .borderlessWithoutBackground:
                return .clear
            case .borderedWithWhiteBackground,
                 .borderlessWithWhiteBackground:
                return KarhooUI.colors.background2
            }
        }

        var borderColor: UIColor {
            switch self {
            case .bordered,
                 .borderedWithWhiteBackground:
                return KarhooUI.colors.border
            case .borderlessWithoutBackground:
                return .clear
            default:
                return KarhooUI.colors.background2
            }
        }
    }

    // MARK: - Properties

    private let pickUp: AddressLabel
    private let destination: AddressLabel
    private let timeLabelText: String?
    private let tags: [Tag]
    private var borderColor: UIColor = KarhooUI.colors.border
    private let borderWidth: CGFloat = 1
    private var cornerRadius: CGFloat = UIConstants.CornerRadius.large
    private var backgroundColor: UIColor = KarhooUI.colors.background2
    private let showsLineBetweenPickUpAndDestination: Bool

    // MARK: - Lifecycle

    init(
        pickUp: AddressLabel,
        destination: AddressLabel,
        design: Design = .borderedWithWhiteBackground,
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
        HStack(alignment: .center, spacing: UIConstants.Spacing.medium) {
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
        .frame(maxWidth: Constants.maxWidth, alignment: .topLeading)
        .background(Color(backgroundColor))
        .addBorder(Color(borderColor), cornerRadius: cornerRadius)
        .colorScheme(.light)
        .layoutPriority(Double(UILayoutPriority.required.rawValue))
    }

    @ViewBuilder
    private var dotsColumn: some View {
        VStack(
            alignment: .center,
            spacing: UIConstants.Spacing.xSmall
        ) {
            Image("kh_uisdk_empty_circle_secondary", bundle: .current)
                .frame(
                    width: Constants.roundIconSide,
                    height: Constants.roundIconSide
                )
            if showsLineBetweenPickUpAndDestination {
                VLine()
                    .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [4, 5]))
                    .frame(width: 2)
                    .frame(minHeight: UIConstants.Spacing.large)
                    .fixedSize()
                    .foregroundColor(Color(KarhooUI.colors.border))
            } else {
                Spacer()
            }

            Image("kh_uisdk_empty_circle_primary", bundle: .current)
                .frame(
                    width: Constants.roundIconSide,
                    height: Constants.roundIconSide
                )
        }
    }

    @ViewBuilder
    private var labelsColumn: some View {
        VStack(alignment: .leading) {
            AddressLabelView(
                accessibilityTitle: UITexts.Generic.pickUp,
                text: pickUp.text,
                subtext: pickUp.subtext
            )
            if tags.isNotEmpty {
                buildTagsView()
            } else {
                Spacer()
                    .frame(height: UIConstants.Spacing.medium)
            }
            AddressLabelView(
                accessibilityTitle: UITexts.Generic.destination,
                text: destination.text,
                subtext: destination.subtext
            )
        }
    }

    @ViewBuilder
    private func buildTimeTextView(_ text: String) -> some View {
        HStack(spacing: 0) {
            Spacer()
                .frame(minWidth: 1, idealWidth: 1, maxWidth: .infinity)
                .fixedSize()
            VStack(spacing: 0) {
                Text(text)
                    .font(Font(KarhooUI.fonts.bodyBold()))
                    .multilineTextAlignment(.trailing)
                    .fixedSize()
                    .minimumScaleFactor(Constants.minimumScaleFactor)
                    .padding(.top, Constants.timeLabelTextTopPadding)
                Spacer()
                    .frame(minHeight: 66, idealHeight: 66, maxHeight: .infinity)
                    .fixedSize()
            }
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

// MARK: - Address label model & view
extension KarhooAddressView {

    struct AddressLabel {
        let text: String
        let subtext: String?
    }

    struct AddressLabelView: View {

        let accessibilityTitle: String
        let text: String
        var subtext: String?

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Text(text)
                    .font(Font(KarhooUI.fonts.bodyRegular()))
                    .foregroundColor(Color(KarhooUI.colors.text))
                    .frame(alignment: .leading)
                if let subtext = subtext, subtext.isNotEmpty {
                    Text(subtext)
                        .font(Font(KarhooUI.fonts.captionBold()))
                        .foregroundColor(Color(KarhooUI.colors.textLabel))
                        .frame(alignment: .leading)
                }
            }
            .frame(height: Constants.labelHeight)
            .accessibilityElement()
            .accessibilityValue(accessibilityText)
        }

        private var accessibilityText: Text {
            Text(accessibilityTitle + ". " + text + ", " + (subtext ?? ""))
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
                .font(Font(KarhooUI.fonts.bodyBold()))
                .frame(height: 14)
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(Color(KarhooUI.colors.primary))
                .foregroundColor(Color(KarhooUI.colors.background2))
                .addBorder(.clear, cornerRadius: 5)
        }
    }
}

// MARK: - Preview
struct KarhooAddressView_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            KarhooAddressView(
                pickUp: .init(text: "London City Airport, Hartmann Rd", subtext: "London E16 2PX, United Kingdom"),
                destination: .init(text: "10 downing st westminster", subtext: "London SW1A 2AA, United Kingdom"),
                design: .bordered,
                timeLabelText: "NOW"
            )
        }
    }
}
