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
        set { textInsets.left = newValue }
        get { return textInsets.left }
    }
    
    @IBInspectable
    var right_TextInset: CGFloat {
        set { textInsets.right = newValue }
        get { return textInsets.right }
    }
    
    @IBInspectable
    var top_TextInset: CGFloat {
        set { textInsets.top = newValue }
        get { return textInsets.top }
    }
    
    @IBInspectable
    var bottom_TextInset: CGFloat {
        set { textInsets.bottom = newValue }
        get { return textInsets.bottom }
    }
    
    @IBInspectable
    var cornerRadious: Bool {
        set { layer.cornerRadius = newValue ? min(frame.size.width, frame.size.height) / 2 : 0}
        get { return layer.cornerRadius != 0 }
    }
    
    @IBInspectable
    var maskToBounds: Bool {
        set { layer.masksToBounds = newValue }
        get { return layer.masksToBounds }
    }
}
