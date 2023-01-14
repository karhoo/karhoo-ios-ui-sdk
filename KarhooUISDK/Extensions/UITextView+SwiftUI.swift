//
//  UITextView+SwiftUI.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 13/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI
import UIKit

struct TextView: UIViewRepresentable {

    @Binding var text: NSAttributedString
    weak var delegate: UITextViewDelegate?

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = text
        uiView.delegate = delegate
        uiView.isSelectable = true
        uiView.isUserInteractionEnabled = true
        uiView.isEditable = false
//        uiView.isScrollEnabled = false
        uiView.backgroundColor = .clear
        uiView.isAccessibilityElement = true
//        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.accessibilityIdentifier = KHTermsConditionsViewID.textView
        uiView.font = UIFont.systemFont(ofSize: 14.0)
        uiView.dataDetectorTypes = .link
        uiView.tintColor = KarhooUI.colors.accent
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        uiView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        uiView.setContentCompressionResistancePriority(.required, for: .vertical)
        if uiView.frame.size != .zero {
            uiView.isScrollEnabled = false
        }
    }
}
