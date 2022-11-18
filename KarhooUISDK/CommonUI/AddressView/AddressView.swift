//
//  AddressView.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 16/11/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import SwiftUI

/// New Address view. Shows pick up, destination and places in between (if needed). View does not provide interactions by default.
struct KarhooAddressView: View {

    var cornerColor: UIColor = KarhooUI.colors.border
    let borderWidth: CGFloat = 1
    var cornerRadius: CGFloat = UIConstants.CornerRadius.large
    var backgroundColor: UIColor = KarhooUI.colors.white

    var body: some View {
        HStack(spacing: UIConstants.Spacing.medium) {
            dotsColumn
            labelsColumn
            Spacer()
        }
        .padding()
        .background(Color(KarhooUI.colors.white))
        .border(Color(cornerColor), width: borderWidth)
        .cornerRadius(cornerRadius)
    }

    @ViewBuilder
    private var dotsColumn: some View {
        VStack(spacing: UIConstants.Spacing.xSmall) {
            Spacer()
            Image("kh_uisdk_empty_circle_secondary", bundle: .current)
                .frame(width: 10, height: 10)
                .alignmentGuide(.pickupAlignmentGuide) { context in
                    context[.pickupAlignmentGuide]
                }
            VLine()
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [6, 5]))
                .frame(width: 2)
                .foregroundColor(Color(KarhooUI.colors.border))
            Image("kh_uisdk_empty_circle_primary", bundle: .current)
                .frame(width: 10, height: 10)
                .alignmentGuide(.destinationAlignmentGuide) { context in
                    context[.destinationAlignmentGuide]
                }
            Spacer()
        }
    }

    @ViewBuilder
    private var labelsColumn: some View {
        VStack(alignment: .leading) {
            AddressLabel(
                text: "London City Airport, Hartmann Rd",
                subtext: "London E16 2PX, United Kingdom"
            ).alignmentGuide(.pickupAlignmentGuide) { context in
                context[.pickupAlignmentGuide]
            }
            Spacer(minLength: UIConstants.Spacing.large)
            AddressLabel(
                text: "10 downing st westminster",
                subtext: "London SW1A 2AA, United Kingdom"
            ).alignmentGuide(.destinationAlignmentGuide) { context in
                context[.destinationAlignmentGuide]
            }
        }
    }

}

struct KarhooAddressView_Preview: PreviewProvider {
    static var previews: some View {
        KarhooAddressView()
    }
}

struct AddressLabel: View {

    let text: String
    let subtext: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(text)
                .font(Font(KarhooUI.fonts.bodyRegular()))
                .foregroundColor(Color(KarhooUI.colors.text))
            Text(subtext)
                .font(Font(KarhooUI.fonts.captionBold()))
                .foregroundColor(Color(KarhooUI.colors.textLabel))
        }
    }
}

extension VerticalAlignment {
    // MARK: - Pick up alignment

    private struct PickUpAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            // Default to bottom alignment if no guides are set.
            context[VerticalAlignment.center]
        }
    }

    static let pickupAlignmentGuide = VerticalAlignment(
        PickUpAlignment.self
    )

    // MARK: - Destination alignment

    private struct DestinationAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            // Default to bottom alignment if no guides are set.
            context[VerticalAlignment.center]
        }
    }

    static let destinationAlignmentGuide = VerticalAlignment(
        DestinationAlignment.self
    )
}

struct VLine: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        }
    }
}

struct HLine: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        }
    }
}
