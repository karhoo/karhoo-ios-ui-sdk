//
//  HintTextView.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

class HintTextView: UIView {
    
    private var textView: UITextView!
    private var placeholderLabel: UILabel!
    private var placeholder: String
    
    init(placeholder: String = "") {
        self.placeholder = placeholder
        super.init(frame: .zero)
        
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.placeholder = ""
        super.init(coder: aDecoder)
    }
    
    private func setUpView() {
        layer.borderWidth = 0.5
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        textView = UITextView(frame: .zero)
        textView.accessibilityIdentifier = "hint_text_view"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = true
        textView.layer.borderColor = UIColor.black.cgColor
        textView.delegate = self
        textView.returnKeyType = .done
        
        addSubview(textView)
        
        let textViewWidth: CGFloat = UIScreen.main.bounds.width - 40.0
        let textViewHeight: CGFloat = 100.0
        
        _ = [textView.widthAnchor.constraint(equalToConstant: textViewWidth),
             textView.heightAnchor.constraint(equalToConstant: textViewHeight),
             textView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             textView.topAnchor.constraint(equalTo: self.topAnchor),
             textView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             textView.bottomAnchor.constraint(equalTo: self.bottomAnchor)].map { $0.isActive = true }
        
        placeholderLabel = UILabel(frame: .zero)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = .lightGray
        placeholderLabel.font = UIFont.systemFont(ofSize: 12.0)
        placeholderLabel.accessibilityIdentifier = "hint_placeholder_label"
        
        addSubview(placeholderLabel)
        
        _ = [placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor,
                                                       constant: 5.0),
             placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor,
                                                   constant: 8.0)].map { $0.isActive = true }
    }
    
    func setBorder(color: UIColor) {
        layer.borderColor = color.cgColor
    }

    func getText() -> String {
        return textView.text
    }
    
    func showVisualFeedBack() {
        animateBorderColor(toColor: .red, duration: 0.3)
    }
}

extension HintTextView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        animateBorderColor(toColor: .black, duration: 0.3)
        placeholderLabel.isHidden = textView.text.count != 0 ? true : false
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
}
