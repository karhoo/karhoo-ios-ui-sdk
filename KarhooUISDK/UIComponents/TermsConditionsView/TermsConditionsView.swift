//
//  TermsConditionsView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

public protocol TermsConditionsViewDelegate: AnyObject {
    func selectedRegistrationTermsConditions()
}

public struct KHTermsConditionsViewID {
    public static let view = "terms_conditions_view"
    public static let textView = "terms_text_view"
}

public final class TermsConditionsView: UIView, UITextViewDelegate {
    
    private var didSetupConstraints = false
    private var termsTextView: UITextView!
    public weak var delegate: TermsConditionsViewDelegate?
    
    init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpView()
    }
    
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHTermsConditionsViewID.view
        
        termsTextView = UITextView()
        termsTextView.isAccessibilityElement = true
        termsTextView.translatesAutoresizingMaskIntoConstraints = false
        termsTextView.accessibilityIdentifier = KHTermsConditionsViewID.textView
        termsTextView.delegate = self
        termsTextView.font = UIFont.systemFont(ofSize: 14.0)
        termsTextView.dataDetectorTypes = .link
        termsTextView.textAlignment = .center
        termsTextView.isSelectable = true
        termsTextView.isEditable = false
        termsTextView.isScrollEnabled = false
        termsTextView.tintColor = KarhooUI.colors.accent
        addSubview(termsTextView)
        
        heightAnchor.constraint(greaterThanOrEqualToConstant: 10.0).isActive = true
        
        updateConstraints()
    }
    
    public override func updateConstraints() {
        if !didSetupConstraints {
            termsTextView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, paddingLeft: 8.0, paddingRight: 8.0)
        }
        
        super.updateConstraints()
    }
    
    public func setBookingTerms(supplier: String?, termsStringURL: String) {
        let text = TermsConditionsStringBuilder()
            .bookingTermsCopy(
                supplierName: supplier,
                termsURL: convert(termsStringURL)
            )
        setText(text)
    }
    
    public func setToRegistrationTerms() {
        setText(TermsConditionsStringBuilder().registrationTermsCopy())
    }

    private func setText(_ attributedText: NSAttributedString) {
        termsTextView.attributedText = attributedText
        termsTextView.accessibilityLabel = attributedText.string.replacingOccurrences(of: "|", with: ".")
    }
    
    private func convert(_ stringURL: String) -> URL {
        return URL(string: stringURL) ?? TermsConditionsStringBuilder.karhooTermsURL()
    }
    
    public func textView(_ textView: UITextView,
                         shouldInteractWith URL: URL,
                         in characterRange: NSRange,
                         interaction: UITextItemInteraction) -> Bool {
        
        if URL.absoluteString == TermsConditionsStringBuilder.karhooTermsURL().absoluteString {
            delegate?.selectedRegistrationTermsConditions()
        }
        return true
    }
}
