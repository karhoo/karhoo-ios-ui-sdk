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
    
    public static func karhooTermsURL() -> URL {
        return URL(string: UITexts.TermsConditions.karhooTermsLink)!
    }

    public static func karhooPrivacyPolicy() -> URL {
        return URL(string: UITexts.TermsConditions.karhooPolicyLink)!
    }

    func registrationTermsCopy() -> NSAttributedString {
        return attributedTermsString(context: "Karhoo",
                                     action: UITexts.Generic.registeringAccountAction,
                                     policyType: UITexts.Generic.cancellationPolicy,
                                     termsURL: TermsConditionsStringBuilder.karhooTermsURL(),
                                     policyURL: TermsConditionsStringBuilder.karhooPrivacyPolicy())
    }

    func bookingTermsCopy(supplierName: String?, termsURL: URL) -> NSAttributedString {
        return bookingAttributedTermsString(fleetName: supplierName,
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
                                                               .foregroundColor: KarhooUI.colors.primary,
                                                               .underlineColor: KarhooUI.colors.accent,
                                                               .underlineStyle: NSUnderlineStyle.single.rawValue]

        let termsAttributes: [NSAttributedString.Key: Any] = [.font: KarhooUI.fonts.captionRegular(),
                                                              .foregroundColor: KarhooUI.colors.primary,
                                                              .underlineStyle: NSUnderlineStyle.single.rawValue,
                                                              .underlineColor: KarhooUI.colors.accent,
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
    
    private func bookingAttributedTermsString(fleetName: String?,
                                              termsURL: URL,
                                              policyURL: URL) -> NSAttributedString {
        guard let fleetName = fleetName
        else {
            return NSAttributedString(string: "")
        }

        // dp stands for Demand Partner. Karhoo provides the default links, but they may be updated by our demand partners
        let dpTermsLink = URL(string: UITexts.TermsConditions.termsLink) ?? TermsConditionsStringBuilder.karhooTermsURL()
        let dpPolicyLink = URL(string: UITexts.TermsConditions.policyLink) ?? TermsConditionsStringBuilder.karhooPrivacyPolicy()
        
        let dpTermsText: String = UITexts.Generic.termsOfUse
        let dpPolicyText: String = UITexts.Generic.privacyPolicy
        let fleetTermsText: String = UITexts.Generic.termsAndConditions
        let fleetPolicyText: String = UITexts.Generic.cancellationPolicy
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 8

        let regularAttributes: [NSAttributedString.Key: Any] = [.font: KarhooUI.fonts.captionRegular(),
                                                                .foregroundColor: KarhooUI.colors.medGrey,
                                                                .paragraphStyle: paragraphStyle]

        let dpPolicyAttributes: [NSAttributedString.Key: Any] = [.font: KarhooUI.fonts.captionRegular(),
                                                               .link: dpPolicyLink,
                                                               .foregroundColor: KarhooUI.colors.primary,
                                                               .underlineColor: KarhooUI.colors.accent,
                                                               .underlineStyle: NSUnderlineStyle.single.rawValue,
                                                               .paragraphStyle: paragraphStyle]

        let dpTermsAttributes: [NSAttributedString.Key: Any] = [.font: KarhooUI.fonts.captionRegular(),
                                                              .foregroundColor: KarhooUI.colors.primary,
                                                              .underlineStyle: NSUnderlineStyle.single.rawValue,
                                                              .underlineColor: KarhooUI.colors.accent,
                                                              .link: dpTermsLink,
                                                              .paragraphStyle: paragraphStyle]
        
        let fleetPolicyAttributes: [NSAttributedString.Key: Any] = [.font: KarhooUI.fonts.captionRegular(),
                                                               .link: policyURL,
                                                               .foregroundColor: KarhooUI.colors.primary,
                                                               .underlineColor: KarhooUI.colors.accent,
                                                               .underlineStyle: NSUnderlineStyle.single.rawValue,
                                                               .paragraphStyle: paragraphStyle]

        let fleetTermsAttributes: [NSAttributedString.Key: Any] = [.font: KarhooUI.fonts.captionRegular(),
                                                              .foregroundColor: KarhooUI.colors.primary,
                                                              .underlineStyle: NSUnderlineStyle.single.rawValue,
                                                              .underlineColor: KarhooUI.colors.accent,
                                                              .link: termsURL,
                                                              .paragraphStyle: paragraphStyle]

        let termsText = NSMutableAttributedString()

        let fullText = String(format: NSLocalizedString(UITexts.TermsConditions.bookingTermAndConditionsFullText,
                                                        comment: ""), dpTermsText, dpPolicyText, fleetName, fleetTermsText, fleetPolicyText)
        
        termsText.append(NSAttributedString(string: fullText, attributes: regularAttributes))

        let dpTermsRange = (termsText.string as NSString).range(of: dpTermsText)
        let dpPolicyRange = (termsText.string as NSString).range(of: dpPolicyText)
        let fleetTermsRange = (termsText.string as NSString).range(of: fleetTermsText)
        let fleetPolicyRange = (termsText.string as NSString).range(of: fleetPolicyText)

        termsText.addAttributes(dpTermsAttributes, range: dpTermsRange)
        termsText.addAttributes(dpPolicyAttributes, range: dpPolicyRange)
        termsText.addAttributes(fleetTermsAttributes, range: fleetTermsRange)
        termsText.addAttributes(fleetPolicyAttributes, range: fleetPolicyRange)

        return termsText
    }

}
