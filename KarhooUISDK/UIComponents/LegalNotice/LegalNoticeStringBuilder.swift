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

private let mockLegalNoticeLink: String = "hexonec587@v3dev.com"
private let mockLegalNotice: String = """
Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil hexonec587@v3dev.com, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur.
"""
