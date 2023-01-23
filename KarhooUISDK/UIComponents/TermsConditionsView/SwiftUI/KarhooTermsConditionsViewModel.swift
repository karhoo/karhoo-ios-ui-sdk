//
//  KarhooTermsConditionsViewModel.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 15/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI
import Combine

class KarhooTermsConditionsViewModel: ObservableObject {

    // MARK: - Dependencies

    private let sdkConfiguration: KarhooUISDKConfiguration

    // MARK: - Properties

    private var cancellables: Set<AnyCancellable> = []
    var isAcceptanceRequired: Bool { sdkConfiguration.isExplicitTermsAndConditionsConsentRequired }

    @Published var buttonBorderColor: Color = .clear
    @Published var showAgreementRequired = false
    @Published var attributedText: NSAttributedString = .init(string: "")
    @Published var accessibilityText: String = ""
    @Published var confirmed: Bool = false
    @Published var imageName: String = "kh_uisdk_checkbox_unselected"

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
            .dropFirst()
            .sink { [weak self] _ in
                self?.updateImageName()
                self?.showAgreementRequired = false
            }
            .store(in: &cancellables)

        $showAgreementRequired
            .sink { [weak self] showAgreementRequired in
                let color = showAgreementRequired ? Color(KarhooUI.colors.error) : .clear
                self?.buttonBorderColor = color
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
