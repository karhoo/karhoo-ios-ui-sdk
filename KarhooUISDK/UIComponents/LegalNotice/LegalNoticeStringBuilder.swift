//
//  LegalNoticeStringBuilder.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 31/01/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//
// swiftlint:disable line_length

import Foundation
import UIKit

struct LegalNoticeStringBuilder {
    
    func getLegalNotice() -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = UIConstants.Spacing.xSmall
        
        let titleForLink: String = UITexts.Booking.legalNoticeTitle
        let link = UITexts.Booking.legalNoticeLink
        let legalNoticeText = NSMutableAttributedString()
        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: KarhooUI.fonts.captionRegular(),
            .foregroundColor: KarhooUI.colors.text,
            .paragraphStyle: paragraphStyle
        ]
        var linkAttibutes: [NSAttributedString.Key: Any] = [
            .font: KarhooUI.fonts.captionRegular(),
            .foregroundColor: KarhooUI.colors.accent,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: KarhooUI.colors.accent,
            .paragraphStyle: paragraphStyle,
            NSAttributedString.Key(rawValue: "link"): "link"
        ]
        if let linkUrl = URL(string: link) {
            linkAttibutes[.link] = linkUrl
        }
        var text: String {
            UITexts.Booking.legalNoticeText
        }
        let fullText = String(format: NSLocalizedString(text, comment: ""), titleForLink)
        legalNoticeText.append(NSAttributedString(string: fullText, attributes: regularAttributes))
        if LinkParser().canOpen(link) {
            let legalNoticeString: NSString = legalNoticeText.string as NSString
            let linkRange = (legalNoticeString).range(of: titleForLink)
            legalNoticeText.addAttributes(linkAttibutes, range: linkRange)
        }
        return legalNoticeText
    }
}
