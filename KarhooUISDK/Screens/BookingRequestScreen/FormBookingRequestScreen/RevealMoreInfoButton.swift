//
//  LearnMoreButton.swift
//  KarhooUISDK
//
//  Created by Anca Feurdean on 18.08.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit

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

final class RevealMoreInfoButton: UIButton {
    private weak var actions: BookingButtonActions?
    private var containerView: UIView!
    private var button: UIButton!
    private var dropdownImage: UIImageView!
    private var buttonLabel: UILabel!
    private var currentMode: ButtonMode?
    private let textTransitionTime = 0.25
    private var didSetupConstraints = false

    init() {
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
        buttonLabel.textColor = KarhooUI.colors.accent
        buttonLabel.textAlignment = .center
        containerView.addSubview(buttonLabel)
        
        dropdownImage = UIImageView(image: UIImage.uisdkImage("dropdownIcon").withRenderingMode(.alwaysTemplate))
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
            dropdownImage.anchor(width: imageSize,
                                 height: imageSize)
            
            button.anchor(top: topAnchor,
                          leading: leadingAnchor,
                          bottom: bottomAnchor,
                          trailing: trailingAnchor)

            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }

    @objc private func learnMorePressed() {
        guard let mode = currentMode else {
            return
        }

        switch mode {
        case .learnMore: actions?.requestPressed()
        case .learnLess: actions?.addFlightDetailsPressed()
        }
    }

    func set(actions: BookingButtonActions) {
        self.actions = actions
    }
}
