//
//  RoundedLabel.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

class RoundedLabel: UILabel {
    
    var textInsets = UIEdgeInsets.zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}

extension RoundedLabel {
    @IBInspectable
    var left_TextInset: CGFloat {
        get { return textInsets.left }
        set { textInsets.left = newValue }
    }
    
    @IBInspectable
    var right_TextInset: CGFloat {
        get { return textInsets.right }
        set { textInsets.right = newValue }
    }
    
    @IBInspectable
    var top_TextInset: CGFloat {
        get { return textInsets.top }
        set { textInsets.top = newValue }
    }
    
    @IBInspectable
    var bottom_TextInset: CGFloat {
        get { return textInsets.bottom }
        set { textInsets.bottom = newValue }
    }
    
    @IBInspectable
    var cornerRadious: Bool {
        get { return layer.cornerRadius != 0 }
        set { layer.cornerRadius = newValue ? min(frame.size.width, frame.size.height) / 2 : 0}
    }
    
    @IBInspectable
    var maskToBounds: Bool {
        get { return layer.masksToBounds }
        set { layer.masksToBounds = newValue }
    }
}
