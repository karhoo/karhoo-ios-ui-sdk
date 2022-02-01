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

        
        
        let legalNoticeText = NSMutableAttributedString()
        
        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: KarhooUI.fonts.captionRegular(),
            .foregroundColor: KarhooUI.colors.text,
            .paragraphStyle: paragraphStyle]

        let emailAttibutes: [NSAttributedString.Key: Any] = [
            .font: KarhooUI.fonts.captionRegular(),
            .foregroundColor: KarhooUI.colors.accent,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: KarhooUI.colors.accent,
            .paragraphStyle: paragraphStyle,
            NSAttributedString.Key(rawValue: "email") : "email"]
        
        let mail: String = UITexts.Booking.legalNoticeMail
        var fullText: String {
            String(format: NSLocalizedString(UITexts.Booking.legalNoticeText,
                                                        comment: ""), mail)
        }
        legalNoticeText.append(NSAttributedString(string: fullText, attributes: regularAttributes))
        
        let emailRange = (legalNoticeText.string as NSString).range(of: mail)
        legalNoticeText.addAttributes(emailAttibutes, range: emailRange)
        
        return legalNoticeText

    }
}
