//
//  LegalNoticeStringBuilder.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 31/01/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

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
        let linkAttibutes: [NSAttributedString.Key: Any] = [
            .font: KarhooUI.fonts.captionRegular(),
            .foregroundColor: KarhooUI.colors.accent,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: KarhooUI.colors.accent,
            .paragraphStyle: paragraphStyle,
            NSAttributedString.Key(rawValue: "link"): "link"
        ]
        var text: String {
            #if DEBUG
            mockLegalNotice
            #else
            UITexts.Booking.legalNoticeText
            #endif
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

private let mockLegalNoticeLink: String = "all-mobility.data.privacy@accor.com"
private let mockLegalNotice: String = """
The data collected are subject to processing by Accor SA for the purpose of managing your booking, getting to know you better, improving the services we provide and the customer experience. These data are sent to Accor SA, restaurants and Accor SA subcontractors. Your data may be transferred outside the European Union when this is necessary for the fulfilment or preparation of your reservation, or when appropriate and adapted guarantees have been established. You have the right to request access to your data, their rectification or erasure, to object to their processing, and to define directives concerning the processing of your data after your death by writing to the following address: all-mobility.data.privacy@accor.com. For more information on the processing of your personal data, please see our personal data protection charter.
"""
