//
//  LearnMoreButton.swift
//  KarhooUISDK
//
//  Created by Anca Feurdean on 18.08.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit

protocol RevealMoreButtonActions: AnyObject {
    func learnMorePressed()
    func learnLessPressed()
}

private enum ButtonMode {
    case learnMore
    case learnLess
    
    var image: UIImage {
        switch self {
        case .learnLess:
            return UIImage.uisdkImage("dropupIcon")
        case .learnMore:
            return UIImage.uisdkImage("dropdownIcon")
        }
    }
    
    var title: String {
        switch self {
        case .learnLess:
            return "Learn less"
        case .learnMore:
            return "Learn more"
        }
    }
}

public struct KHRevealMoreButtonViewID {
    public static let container = "revealing_button_container"
    public static let button = "revealing_button_view"
    public static let buttonTitle = "title_label"
    public static let image = "dropdown_up_icon"
}

final class RevealMoreInfoButton: UIButton {
    private weak var actions: RevealMoreButtonActions?
    private var containerView: UIView!
    private var button: UIButton!
    private var buttonLabel: UILabel!
    private var currentMode: ButtonMode
    private var didSetupConstraints = false

    private lazy var dropdownImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    init() {
        currentMode = .learnMore
        
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHRevealMoreButtonViewID.button
        
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.accessibilityIdentifier = KHRevealMoreButtonViewID.container
        containerView.backgroundColor = .clear
        addSubview(containerView)
        
        buttonLabel = UILabel()
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonLabel.accessibilityIdentifier = KHRevealMoreButtonViewID.buttonTitle
        buttonLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        buttonLabel.text = currentMode.title
        buttonLabel.textColor = KarhooUI.colors.accent
        buttonLabel.textAlignment = .center
        containerView.addSubview(buttonLabel)
        
        dropdownImage.image = currentMode.image
        dropdownImage.accessibilityIdentifier = KHRevealMoreButtonViewID.image
        dropdownImage.translatesAutoresizingMaskIntoConstraints = false
        dropdownImage.tintColor = KarhooUI.colors.accent
        dropdownImage.contentMode = .scaleAspectFill
        containerView.addSubview(dropdownImage)
        
        button = UIButton(type: .custom)
        button.accessibilityIdentifier = KHBookingButtonViewID.button
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(learnMorePressed), for: .touchUpInside)
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
            actions?.learnMorePressed()
        case .learnLess:
            currentMode = .learnMore
            actions?.learnLessPressed()
        }
        
        dropdownImage.image = currentMode.image
        buttonLabel.text = currentMode.title
    }

    func set(actions: RevealMoreButtonActions) {
        self.actions = actions
    }
}
