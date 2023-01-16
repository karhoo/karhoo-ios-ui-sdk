//
//  KarhooTermsConditionsView.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 13/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI
import Combine

struct KarhooTermsConditionsView: View {

    private enum Constants {
        static let imageSize = CGSize(width: 20, height: 20)
    }
    @StateObject var viewModel: KarhooTermsConditionsViewModel

    var body: some View {
        HStack(alignment: .top, spacing: UIConstants.Spacing.small) {
            if viewModel.isAcceptanceRequired {
                Button(
                    action: {
                        viewModel.confirmed.toggle()
                },
                    label: {
                        Image(viewModel.imageName, bundle: .current)
                            .resizable()
                            .foregroundColor(Color(KarhooUI.colors.border))
                            .frame(width: Constants.imageSize.width, height: Constants.imageSize.height)
                    }
                )
            }

            TextView($viewModel.attributedText)
                .accessibilityValue(viewModel.accessibilityText)
        }
    }
}

class KarhooTermsConditionsViewModel: ObservableObject {

    // MARK: - Dependencies

    private let sdkConfiguration: KarhooUISDKConfiguration

    // MARK: - Properties

    private var cancellables: Set<AnyCancellable> = []
    var isAcceptanceRequired: Bool { sdkConfiguration.isExplicitTermsAndConditionsConsentRequired }

    @Published var attributedText: NSAttributedString = .init(string: "")
    @Published var accessibilityText: String = ""
    @Published var confirmed: Bool = false { didSet {
        updateImageName()
    }}
    @Published var imageName: String = "kh_uisdk_checkbox_selected"

    // MARK: - Lifecycle

    init(
        sdkConfiguration: KarhooUISDKConfiguration = KarhooUISDKConfigurationProvider.configuration,
        supplier: String?,
        termsStringURL: String
    ) {
        self.sdkConfiguration = sdkConfiguration
        self.setBookingTerms(supplier: supplier, termsStringURL: termsStringURL)
        self.setupBinding()
    }

    // MARK: - Setup

    private func setBookingTerms(supplier: String?, termsStringURL: String) {
        let text = TermsConditionsStringBuilder()
            .bookingTermsCopy(
                supplierName: supplier,
                termsURL: convert(termsStringURL)
            )
        setText(text)
    }

    private func setupBinding() {
        $confirmed
            .sink { [weak self] _ in
                self?.updateImageName()
            }
            .store(in: &cancellables)
    }

    // MARK: - Helpers

    private func convert(_ stringURL: String) -> URL {
        URL(string: stringURL) ?? TermsConditionsStringBuilder.karhooTermsURL()
    }

    private func setText(_ attributedText: NSAttributedString) {
        let text = NSMutableAttributedString(attributedString: attributedText).then {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = isAcceptanceRequired ? .left : .center
            $0.addAttribute(
                .paragraphStyle,
                value: paragraphStyle,
                range: NSRange.init(location: 0, length: $0.length)
            )
        }
        self.attributedText = text
        self.accessibilityText = text.string.replacingOccurrences(of: "|", with: ".")
    }

    private func updateImageName() {
        var newImageName: String {
            switch confirmed {
            case true: return "kh_uisdk_checkbox_selected"
            case false: return "kh_uisdk_checkbox_unselected"
            }
        }
        imageName = newImageName
    }
}
