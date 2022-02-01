//
//  KarhooLegalNoticeView.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 26/01/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation


public struct KHLegalNoticeViewID {
    public static let view = "legal_notice_view"
    public static let button = "legal_notice_button"
    public static let text = "legal_notice_text"
}

final class KarhooLegalNoticeView: UIView, UITextViewDelegate {
    
    let isAvailable: Bool = UITexts.Booking.learnMore.isNotEmpty
    private weak var viewController: UIViewController?
    private let legalNoticeMailComposer: KarhooLegalNoticeMailComposer
    
    private var didSetUpConstraints: Bool = false
    private var legalNoticeTextView: UITextView!
    
        private lazy var legalNoticeButton: KarhooExpandViewButton = {
            let button = KarhooExpandViewButton(title: UITexts.Booking.learnMore, onExpand: hideLegalNoticePressed, onCollapce: showLegalNoticePressed)
            button.accessibilityIdentifier = KHLegalNoticeViewID.button
            button.anchor(height: 44.0)
            return button
        }()
    
    private var attributedLabel: UILabel = {
        let legalNoticeLabel = UILabel()
        legalNoticeLabel.translatesAutoresizingMaskIntoConstraints = false
        legalNoticeLabel.accessibilityIdentifier = KHLegalNoticeViewID.text
        legalNoticeLabel.font = KarhooUI.fonts.captionRegular()
        legalNoticeLabel.textAlignment = .justified
        legalNoticeLabel.attributedText = LegalNoticeStringBuilder().legalNotice()
        legalNoticeLabel.numberOfLines = 0
        legalNoticeLabel.isUserInteractionEnabled = true
        return legalNoticeLabel
    }()
    
    //MARK: - Init
    init(parent: UIViewController, mailComposer: KarhooLegalNoticeMailComposer) {
        self.viewController = parent
        self.legalNoticeMailComposer = mailComposer
        super.init(frame: .zero)
        self.setUpView()
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    private func setUpView() {
        accessibilityIdentifier = KHLegalNoticeViewID.view
        translatesAutoresizingMaskIntoConstraints = false
        
        attributedLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.singleTap(_:))))
        
        addSubview(legalNoticeButton)
        addSubview(attributedLabel)
        hideLegalNoticePressed()
    }
    
    override func updateConstraints() {
        if !didSetUpConstraints {
            legalNoticeButton.anchor(
                top: topAnchor,
                trailing: trailingAnchor,
                paddingLeft: 8.0,
                paddingRight: 8.0)
            
            attributedLabel.anchor(
                top: legalNoticeButton.bottomAnchor,
                leading: leadingAnchor,
                bottom: bottomAnchor,
                trailing: trailingAnchor,
                paddingLeft: 8.0,
                paddingBottom: 16,
                paddingRight: 8.0)
            
            didSetUpConstraints.toggle()
        }
        super.updateConstraints()
    }
    
    @objc func singleTap(_ tap : UITapGestureRecognizer) {
           let attributedText = NSMutableAttributedString(attributedString: self.attributedLabel.attributedText!)
        attributedText.addAttributes([NSAttributedString.Key.font: self.attributedLabel.font as UIFont], range: NSMakeRange(0, (self.attributedLabel.attributedText?.string.count)!))

           // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
           let layoutManager = NSLayoutManager()
           let textContainer = NSTextContainer(size: CGSize(width: (self.attributedLabel.frame.width), height: (self.attributedLabel.frame.height)+100))
           let textStorage = NSTextStorage(attributedString: attributedText)

           // Configure layoutManager and textStorage
           layoutManager.addTextContainer(textContainer)
           textStorage.addLayoutManager(layoutManager)

           // Configure textContainer
           textContainer.lineFragmentPadding = 0.0
           textContainer.lineBreakMode = self.attributedLabel.lineBreakMode
           textContainer.maximumNumberOfLines = self.attributedLabel.numberOfLines
           let labelSize = self.attributedLabel.bounds.size
           textContainer.size = labelSize

           let tapLocation = tap.location(in: self.attributedLabel)

           // get the index of character where user tapped
           let index = layoutManager.characterIndex(for: tapLocation, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

           if index > (self.attributedLabel.text?.count)! { return }
           var range : NSRange = NSRange()
        if let _ = self.attributedLabel.attributedText?.attribute(NSAttributedString.Key(rawValue: "email"), at: index, effectiveRange: &range) as? String {
            _ = self.legalNoticeMailComposer.showLegalNoticekMail()
           }
       }
    
    func showLegalNoticePressed(){
        UIView.animate(withDuration: 0.45) { [unowned self] in
            self.attributedLabel.alpha = 1.0
            self.attributedLabel.isHidden = false
        }
    }
    
    func hideLegalNoticePressed(){
        UIView.animate(withDuration: 0.45) {
            self.attributedLabel.alpha = 0.0
            self.attributedLabel.isHidden = true
        }
    }
}
