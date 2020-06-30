//
//  LinkLabel.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

final class LinkLabel: UILabel {

    private let layoutManager = NSLayoutManager()
    private let textContainer = NSTextContainer(size: CGSize.zero)
    private var textStorage = NSTextStorage() {
        didSet {
            textStorage.addLayoutManager(layoutManager)
        }
    }
    private let tapGesture = UITapGestureRecognizer()

    var onCharacterTapped: ((_ label: UILabel, _ characterIndex: Int) -> Void)?

    override var attributedText: NSAttributedString? {
        didSet {
            if let attributedText = attributedText {
                textStorage = NSTextStorage(attributedString: attributedText)
            } else {
                textStorage = NSTextStorage()
            }
        }
    }
    override var lineBreakMode: NSLineBreakMode {
        didSet {
            textContainer.lineBreakMode = lineBreakMode
        }
    }

    override var numberOfLines: Int {
        didSet {
            textContainer.maximumNumberOfLines = numberOfLines
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        isUserInteractionEnabled = true
        layoutManager.addTextContainer(textContainer)
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
        tapGesture.addTarget(self, action: #selector(LinkLabel.labelTapped(_:)))
        addGestureRecognizer(tapGesture)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        textContainer.size = bounds.size
    }

    @objc func labelTapped(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else {
            return
        }
        let locationOfTouch = gesture.location(in: gesture.view)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (bounds.width - textBoundingBox.width) / 2 - textBoundingBox.minX,
                                          y: (bounds.height - textBoundingBox.height) / 2 - textBoundingBox.minY)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouch.x - textContainerOffset.x,
                                                     y: locationOfTouch.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer,
                                                            in: textContainer,
                                                            fractionOfDistanceBetweenInsertionPoints: nil)
        onCharacterTapped?(self, indexOfCharacter)
    }
}
