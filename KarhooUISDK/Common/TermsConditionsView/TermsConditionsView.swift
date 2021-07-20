//
//  TermsConditionsView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

public protocol TermsConditionsViewDelegate: class {
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
            _ = [termsTextView.topAnchor.constraint(equalTo: topAnchor),
                 termsTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
                 termsTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0),
                 termsTextView.bottomAnchor.constraint(equalTo: bottomAnchor)].map { $0.isActive = true }
        }
        
        super.updateConstraints()
    }
    
    public func setBookingTerms(supplier: String?, termsStringURL: String) {
        termsTextView.attributedText = TermsConditionsStringBuilder()
            .bookingTermsCopy(supplierName: supplier,
                              termsURL: convert(termsStringURL))
    }
    
    public func setToRegistrationTerms() {
        termsTextView.attributedText = TermsConditionsStringBuilder().registrationTermsCopy()
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
