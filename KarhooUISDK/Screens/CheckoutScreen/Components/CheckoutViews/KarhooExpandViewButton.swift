//
//  KarhooExpandViewButton.swift
//  KarhooUISDK
//
//  Created by Anca Feurdean on 18.08.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit

protocol ExpandViewButtonDelegate: AnyObject {
    func learnMorePressed()
    func learnLessPressed()
}

private enum ButtonMode {
    case learnMore
    case learnLess
}

public struct KHRevealMoreButtonViewID {
    public static let container = "revealing_button_container"
    public static let button = "revealing_button_view"
    public static let buttonTitle = "title_label"
    public static let image = "dropdown_up_icon"
}

final class KarhooExpandViewButton: UIButton {
    private var title: String
    private var onExpandAction: () -> Void
    private var onCollapseAction: () -> Void

    
    private var currentMode: ButtonMode = .learnMore
    private var didSetupConstraints = false
    
    private var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.accessibilityIdentifier = KHRevealMoreButtonViewID.container
        containerView.backgroundColor = .clear
        
        return containerView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.accessibilityIdentifier = KHBookingButtonViewID.button
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(learnMorePressed), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var buttonLabel: UILabel = {
        let buttonLabel = UILabel()
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonLabel.accessibilityIdentifier = KHRevealMoreButtonViewID.buttonTitle
        buttonLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        buttonLabel.text = title
        buttonLabel.textColor = KarhooUI.colors.accent
        buttonLabel.textAlignment = .center
        
        return buttonLabel
    }()

    private lazy var dropdownImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.uisdkImage("dropdownIcon")
        imageView.accessibilityIdentifier = KHRevealMoreButtonViewID.image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = KarhooUI.colors.accent
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    init(title: String, onExpand: @escaping () -> Void, onCollapce: @escaping () -> Void) {
        self.title = title
        self.onExpandAction = onExpand
        self.onCollapseAction = onCollapce
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHRevealMoreButtonViewID.button
        
        addSubview(containerView)
        
        containerView.addSubview(buttonLabel)
        containerView.addSubview(dropdownImage)
        containerView.addSubview(button)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            containerView.anchor(top: topAnchor,
                                 leading: leadingAnchor,
                                 bottom: bottomAnchor,
                                 trailing: trailingAnchor,
                                 paddingLeft: 5.0,
                                 paddingRight: 5.0)
            
            buttonLabel.anchor(top: topAnchor,
                               leading: containerView.leadingAnchor,
                               bottom: bottomAnchor,
                               trailing: dropdownImage.leadingAnchor,
                               paddingTop: 5.0,
                               paddingBottom: 5.0,
                               paddingRight: 5.0)
            
            let imageSize: CGFloat = 16.0
            dropdownImage.centerY(inView: self)
            dropdownImage.anchor(trailing: containerView.trailingAnchor,
                                 width: imageSize,
                                 height: imageSize)
            
            button.anchor(top: containerView.topAnchor,
                          leading: buttonLabel.leadingAnchor,
                          bottom: containerView.bottomAnchor,
                          trailing: containerView.trailingAnchor)

            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }

    @objc private func learnMorePressed() {
        switch currentMode {
        case .learnMore:
            currentMode = .learnLess
            UIView.animate(withDuration: 0.45, animations: { [unowned self] in
                self.dropdownImage.transform = CGAffineTransform(rotationAngle: .pi)
            })
            onCollapseAction()
        case .learnLess:
            currentMode = .learnMore
            UIView.animate(withDuration: 0.45, animations: { [unowned self] in
                self.dropdownImage.transform = CGAffineTransform.identity
            })
            onExpandAction()
        }
    }
}
