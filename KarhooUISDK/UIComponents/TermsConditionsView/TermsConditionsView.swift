//
//  TermsConditionsView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

@available(*, deprecated, message: "Public access to this protocol will be removed in next release")
public protocol TermsConditionsViewDelegate: AnyObject {
    func selectedRegistrationTermsConditions()
}

public struct KHTermsConditionsViewID {
    public static let view = "terms_conditions_view"
    public static let textView = "terms_text_view"
}

@available(*, deprecated, message: "Public access to this view will be removed in next release")
public final class TermsConditionsView: UIView, UITextViewDelegate {

    // MARK: - Nested type

    private enum Mode {
        case acceptRequired
        case `default`
    }

    // MARK: - Properties

    public weak var delegate: TermsConditionsViewDelegate?

    public var isAccepted: Bool {
        checkboxView.isSelected
    }

    private let isAcceptanceRequired: Bool

    // MARK: Views

    private let termsTextView = UITextView().then {
        $0.isAccessibilityElement = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.accessibilityIdentifier = KHTermsConditionsViewID.textView
        $0.font = UIFont.systemFont(ofSize: 14.0)
        $0.dataDetectorTypes = .link
        $0.isSelectable = true
        $0.isEditable = false
        $0.isScrollEnabled = false
        $0.tintColor = KarhooUI.colors.accent
    }

    private lazy var checkboxView = CheckboxView()

    // MARK: - Lifecycle
    
    init(isAcceptanceRequired: Bool = false) {
        self.isAcceptanceRequired = isAcceptanceRequired
        super.init(frame: .zero)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        self.isAcceptanceRequired = false
        super.init(coder: coder)
        self.setUpView()
    }

    // MARK: - Setup

    private func setUpView() {
        setupProperties()
        setupHierarchy()
        setupLayout()
    }
    
    private func setupProperties() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHTermsConditionsViewID.view
        termsTextView.delegate = self
    }

    private func setupHierarchy() {
        addSubview(termsTextView)
        if isAcceptanceRequired { addSubview(checkboxView) }
    }

    private func setupLayout() {
        heightAnchor.constraint(greaterThanOrEqualToConstant: 10.0).isActive = true
        isAcceptanceRequired ? setupLayoutWithCheckbox() : setupLayoutWithoutCheckbox()
    }

    private func setupLayoutWithoutCheckbox() {
        termsTextView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            paddingLeft: UIConstants.Spacing.standard,
            paddingRight: UIConstants.Spacing.standard
        )
    }

    private func setupLayoutWithCheckbox() {
        checkboxView.anchor(
            top: termsTextView.topAnchor,
            leading: leadingAnchor,
            paddingTop: UIConstants.Spacing.xSmall,
            paddingLeft: UIConstants.Spacing.standard - CheckboxView.CustomConstants.visibleAndActualWidthOffset / 2
        )
        termsTextView.anchor(
            top: topAnchor,
            leading: checkboxView.trailingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            paddingLeft: UIConstants.Spacing.xxSmall + CheckboxView.CustomConstants.visibleAndActualWidthOffset / 2,
            paddingRight: UIConstants.Spacing.standard
        )
    }

    // MARK: - Public

    public func showNoAcceptanceError(_ showError: Bool = true) {
        checkboxView.showsError = showError
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

    public func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {
        if URL.absoluteString == TermsConditionsStringBuilder.karhooTermsURL().absoluteString {
            delegate?.selectedRegistrationTermsConditions()
        }
        return true
    }

    // MARK: - Helpers
    
    private func setText(_ attributedText: NSAttributedString) {
        let text = NSMutableAttributedString(attributedString: attributedText).then {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = isAcceptanceRequired ? .left : .center
            $0.addAttribute(
                .paragraphStyle,
                value: paragraphStyle,
                range: NSRange.init(location: 0, length: $0.length)
            )
        }
        termsTextView.attributedText = text
        termsTextView.accessibilityLabel = text.string.replacingOccurrences(of: "|", with: ".")
    }

    private func convert(_ stringURL: String) -> URL {
        URL(string: stringURL) ?? TermsConditionsStringBuilder.karhooTermsURL()
    }
}
