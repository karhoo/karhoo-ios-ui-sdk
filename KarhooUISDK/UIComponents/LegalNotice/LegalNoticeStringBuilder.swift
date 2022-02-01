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
        
        let regularAttributes: [NSAttributedString.Key: Any] = [.font: KarhooUI.fonts.captionRegular(),
                                                                .foregroundColor: KarhooUI.colors.text,
                                                                .paragraphStyle: paragraphStyle]

        let emailAttibutes: [NSAttributedString.Key: Any] = [.font: KarhooUI.fonts.captionRegular(),
                                                            .foregroundColor: KarhooUI.colors.primary,
                                                            .underlineStyle: NSUnderlineStyle.single.rawValue,
                                                            .underlineColor: KarhooUI.colors.accent,
                                                            .paragraphStyle: paragraphStyle,
                                                             NSAttributedString.Key(rawValue: "email") : "email"]
        
        let email: String = "contact@karhoo.com"
        var fullText: String {
            String(format: NSLocalizedString("Lorem ipsum dolor sit amet %1$@ consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ",
                                                        comment: ""), email)
        }
        legalNoticeText.append(NSAttributedString(string: fullText, attributes: regularAttributes))
        
        let emailRange = (legalNoticeText.string as NSString).range(of: email)
        legalNoticeText.addAttributes(emailAttibutes, range: emailRange)
        
//        let emailAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key(rawValue: "email") : "email"]
        return legalNoticeText

    }
}
