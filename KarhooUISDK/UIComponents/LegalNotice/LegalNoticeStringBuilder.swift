//
//  LegalNoticeStringBuilder.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 31/01/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit

public struct LegalNoticeStringBuilder {
    
    func legalNotice() -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 4
        
        let titleForLink: String = UITexts.Booking.legalNoticeMail
        let link = UITexts.Booking.legalNoticeMail

        let legalNoticeText = NSMutableAttributedString()
        
        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: KarhooUI.fonts.captionRegular(),
            .foregroundColor: KarhooUI.colors.text,
            .paragraphStyle: paragraphStyle]

        let linklAttibutes: [NSAttributedString.Key: Any] = [
            .font: KarhooUI.fonts.captionRegular(),
            .foregroundColor: KarhooUI.colors.accent,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: KarhooUI.colors.accent,
            .paragraphStyle: paragraphStyle,
            NSAttributedString.Key(rawValue: "link"):"link"]
        
        var fullText: String {
            String(format: NSLocalizedString(UITexts.Booking.legalNoticeText,
                                                        comment: ""), titleForLink)
        }
        legalNoticeText.append(NSAttributedString(string: fullText, attributes: regularAttributes))
        
        if LinkParser().formatIsSupported(link) {
            let linkRange = (legalNoticeText.string as NSString).range(of: titleForLink)
            legalNoticeText.addAttributes(linklAttibutes, range: linkRange)
        }
        return legalNoticeText
    }
}
