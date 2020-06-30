//
//  TermsConditionsStringBuilder.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import UIKit

public struct TermsConditionsStringBuilder {

    public static var karhooTermsURLString: String {
        #if PRODUCTION
            return "https://cdn.karhoo.com/d/terms/KarhooAppTerms/Karhoo_terms_and_conditions.html"
        #else
            return "https://cdn.karhoo.com/d/terms/KarhooAppTerms/Karhoo_terms_and_conditions.html"
        #endif
    }

    public static var karhooPrivacyPolicyURLString: String {
        #if PRODUCTION
            return "https://cdn.karhoo.com/d/terms/KarhooAppTerms/Karhoo_privacy.html"
        #else
            return "https://cdn.karhoo.com/d/terms/KarhooAppTerms/Karhoo_privacy.html"
        #endif
    }

    public static func karhooTermsURL() -> URL {
        return URL(string: karhooTermsURLString)!
    }

    public static func karhooPrivacyPolicy() -> URL {
        return URL(string: karhooPrivacyPolicyURLString)!
    }

    func registrationTermsCopy() -> NSAttributedString {
        return attributedTermsString(context: "Karhoo",
                                     action: UITexts.Generic.registeringAccountAction,
                                     policyType: UITexts.Generic.privacyPolicy,
                                     termsURL: TermsConditionsStringBuilder.karhooTermsURL(),
                                     policyURL: TermsConditionsStringBuilder.karhooPrivacyPolicy())
    }

    func bookingTermsCopy(supplierName: String?, termsURL: URL) -> NSAttributedString {
        return attributedTermsString(context: supplierName,
                                     action: UITexts.Generic.makingABookingAction,
                                     policyType: UITexts.Generic.cancellationPolicy,
                                     termsURL: termsURL,
                                     policyURL: termsURL) // future proof for fleet cancellation policy urls
    }

    private func attributedTermsString(context: String?,
                                       action: String?,
                                       policyType: String,
                                       termsURL: URL,
                                       policyURL: URL) -> NSAttributedString {
        guard let context = context, let action = action else {
            return NSAttributedString(string: "")
        }

        let termsLink: String = UITexts.Generic.termsAndConditions
        let policyLink: String = policyType
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let regularAttributes: [NSAttributedString.Key: Any] = [.font: KarhooUI.fonts.captionRegular(),
                                                                .foregroundColor: KarhooUI.colors.medGrey,
                                                                .paragraphStyle: paragraphStyle]

        let policyAttributes: [NSAttributedString.Key: Any] = [.font: KarhooUI.fonts.captionRegular(),
                                                               .link: policyURL,
                                                               .foregroundColor: KarhooUI.colors.primary]

        let termsAttributes: [NSAttributedString.Key: Any] = [.font: KarhooUI.fonts.captionRegular(),
                                                              .foregroundColor: KarhooUI.colors.primary,
                                                              .link: termsURL]

        let termsText = NSMutableAttributedString()

        let fullText = String(format: NSLocalizedString(UITexts.TermsConditions.termsConditionFullString,
                                                        comment: ""), action, context, termsLink, policyLink)
        
        termsText.append(NSAttributedString(string: fullText, attributes: regularAttributes))

        let termsRange = (termsText.string as NSString).range(of: termsLink)
        let policyRange = (termsText.string as NSString).range(of: policyLink)

        termsText.addAttributes(policyAttributes, range: policyRange)
        termsText.addAttributes(termsAttributes, range: termsRange)

        return termsText
    }

}
