//
//  LegalNoticeViewController.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 10/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import UIKit


public struct KHLegalNoticeViewID {
    public static let view = "legal_notice_view"
    public static let button = "legal_notice_button"
    public static let text = "legal_notice_text"
}

final class LegalNoticeViewController: UIViewController, BaseViewController {
    
    private var zeroHeightTextConstreint: NSLayoutConstraint!
    private var linkOpener: LegalNoticeLinkOpener!
    private let shouldShowView = UITexts.Booking.legalNoticeText.isNotEmpty
    private let presenter: LegalNoticePresenter

    
    private lazy var legalNoticeButton: KarhooExpandViewButton = {
        let button = KarhooExpandViewButton(
            title: UITexts.Booking.legalNotice,
            initialMode: .open,
            onExpand:  { [weak self] in
                self?.showLegalNoticePressed()
            },
            onCollapce:{[weak self] in
                self?.hideLegalNoticePressed()
            })
        button.accessibilityIdentifier = KHLegalNoticeViewID.button
        button.anchor(height: UIConstants.Dimension.Button.standard)
        return button
    }()
    
    private let attributedLabel: UILabel = {
        let legalNoticeLabel = UILabel()
        legalNoticeLabel.translatesAutoresizingMaskIntoConstraints = false
        legalNoticeLabel.accessibilityIdentifier = KHLegalNoticeViewID.text
        legalNoticeLabel.font = KarhooUI.fonts.captionRegular()
        legalNoticeLabel.textAlignment = .justified
        legalNoticeLabel.attributedText = LegalNoticeStringBuilder().getLegalNotice()
        legalNoticeLabel.numberOfLines = 0
        legalNoticeLabel.isUserInteractionEnabled = true
        return legalNoticeLabel
    }()
    
    // MARK: - Init
    init(presenter: LegalNoticePresenter){
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        linkOpener = KarhooLegalNoticeLinkOpener(viewControllerToPresentFrom: self)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.accessibilityIdentifier = KHLegalNoticeViewID.view
        view.translatesAutoresizingMaskIntoConstraints = false
        super.loadView()
        setUpView()
    }
    
    private func setUpView() {
        if presenter.shouldShowView {
            view.addSubview(legalNoticeButton)
            view.addSubview(attributedLabel)
            zeroHeightTextConstreint = attributedLabel.heightAnchor.constraint(equalToConstant: 0)
            legalNoticeButton.anchor(
                top: view.topAnchor,
                leading: view.leadingAnchor,
                bottom: attributedLabel.topAnchor,
                paddingLeft: UIConstants.Spacing.small,
                paddingRight: UIConstants.Spacing.small
            )
            attributedLabel.anchor(
                top: legalNoticeButton.bottomAnchor,
                leading: view.leadingAnchor,
                bottom: view.bottomAnchor,
                trailing: view.trailingAnchor,
                paddingLeft: UIConstants.Spacing.small,
                paddingBottom: UIConstants.Spacing.standard,
                paddingRight: UIConstants.Spacing.small
            )
            attributedLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(textViewClicked(_:))))
        }
    }
    
    @objc private func textViewClicked(_ tap : UITapGestureRecognizer) {
        let valueForAttributedLink = "link"
        guard let attributedString = attributedLabel.attributedText else {
            assertionFailure("Atrtributed string for legal notice equal nil")
            return
        }
        let attributedText = NSMutableAttributedString(attributedString: attributedString)
        attributedText.addAttributes(
            [NSAttributedString.Key.font: attributedLabel.font as UIFont],
            range: NSMakeRange(0, attributedText.length)
        )
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize(width: attributedLabel.frame.width, height: attributedLabel.frame.height + 100))
        let textStorage = NSTextStorage(attributedString: attributedText)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = attributedLabel.lineBreakMode
        textContainer.maximumNumberOfLines = attributedLabel.numberOfLines
        let labelSize = attributedLabel.bounds.size
        textContainer.size = labelSize
        let tapLocation = tap.location(in: attributedLabel)

        // get the index of character where user tapped
        let index = layoutManager.characterIndex(for: tapLocation, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        guard let attributedLabelTextCount = attributedLabel.text?.count else { return }
        if index > attributedLabelTextCount { return }
        var range : NSRange = NSRange()
        let attributeOfClickedText = attributedLabel.attributedText?.attribute(NSAttributedString.Key(rawValue: "link"), at: index, effectiveRange: &range) as? String
        if attributeOfClickedText ==  valueForAttributedLink {
            linkOpener?.openLink(link: UITexts.Booking.legalNoticeLink)
       }
    }
    
    private func showLegalNoticePressed(){
        zeroHeightTextConstreint.isActive = false
    }
    
    private func hideLegalNoticePressed(){
        zeroHeightTextConstreint.isActive = true
    }
}
