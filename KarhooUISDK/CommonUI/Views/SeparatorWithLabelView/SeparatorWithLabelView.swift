//
//  SeparatorWithLabelView.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 07.02.2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import UIKit

struct KHSeparatorWithLabelViewID {
    public static let containerStackView = "container_stack_view"
    public static let leftSeparator = "left_separator_view"
    public static let rightSeparator = "right_separator_view"
    public static let label = "label"
}

final class SeparatorWithLabelView: UIView {
    private lazy var leftSeparator = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = KarhooUI.colors.border
        $0.accessibilityIdentifier = KHSeparatorWithLabelViewID.leftSeparator
    }
    
    private lazy var rightSeparator = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = KarhooUI.colors.border
        $0.accessibilityIdentifier = KHSeparatorWithLabelViewID.rightSeparator
    }
    
    private lazy var label = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.accessibilityIdentifier = KHSeparatorWithLabelViewID.label
        $0.text = UITexts.Generic.or.uppercased()
        $0.font = KarhooUI.fonts.captionRegular()
        $0.textColor = KarhooUI.colors.textLabel
    }
    
    private var didSetupConstraints: Bool = false
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHSeparatorWithLabelViewID.containerStackView
        
        addSubview(leftSeparator)
        addSubview(label)
        addSubview(rightSeparator)
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            label.centerX(inView: self)
            label.anchor(top: topAnchor, bottom: bottomAnchor)
            
            leftSeparator.anchor(
                leading: leadingAnchor,
                trailing: label.leadingAnchor,
                paddingRight: UIConstants.Spacing.medium,
                height: UIConstants.Dimension.Separator.height
            )
            leftSeparator.centerY(inView: self)
            
            rightSeparator.anchor(
                leading: label.trailingAnchor,
                trailing: trailingAnchor,
                paddingLeft: UIConstants.Spacing.medium,
                height: UIConstants.Dimension.Separator.height
            )
            rightSeparator.centerY(inView: self)
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
}
