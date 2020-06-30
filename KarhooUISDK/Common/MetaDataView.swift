//
//  MetaDataView.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

public struct KHMetaDataViewID {
    public static let titleLabel = "metaData_title_label"
    public static let valueLabel = "metaData_value_label"
    public static let baseFareIcon = "metaData_base_fare_icon"
    public static let statusIcon = "metaData_status_icon"
    public static let actionButton = "metaData_actionButton"
}

final class MetaDataView: UIView {
    
    private var titleLabel: UILabel!
    var actionButton: UIButton! // make private and add delegate for action
    private var valueLabel: UILabel!
    private var baseFareIcon: UIImageView!
    private var statusIcon: UIImageView!
    private var bottomLine: LineView!
    private var titleText: String = ""
    private var identifier: String = "metadata_view"
    
    public init(title: String = "", accessibilityIdentifier: String = "metadata_view") {
        self.titleText = title
        super.init(frame: .zero)
        self.identifier = accessibilityIdentifier
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
        accessibilityIdentifier = identifier
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        
        titleLabel = UILabel()
        titleLabel.accessibilityIdentifier = KHMetaDataViewID.titleLabel
        titleLabel.isAccessibilityElement = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = titleText
        titleLabel.textColor = KarhooUI.colors.medGrey
        titleLabel.font = KarhooUI.fonts.bodyRegular()
        titleLabel.numberOfLines = 0
        
        bottomLine = LineView(color: .lightGray,
                              accessibilityIdentifier: "metadata_bottom_separator")
        addSubview(bottomLine)
        _ = [bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             bottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
             bottomLine.heightAnchor.constraint(equalToConstant: 1.0)].map { $0.isActive = true }
        
        addSubview(titleLabel)
        _ = [titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
             titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0),
             titleLabel.bottomAnchor.constraint(equalTo: bottomLine.topAnchor,
                                                constant: -9.0)].map { $0.isActive = true }
        
        baseFareIcon = UIImageView(image: UIImage.uisdkImage("baseFare"))
        baseFareIcon.accessibilityIdentifier = KHMetaDataViewID.baseFareIcon
        baseFareIcon.translatesAutoresizingMaskIntoConstraints = false
        baseFareIcon.isHidden = true
        baseFareIcon.tintColor = KarhooUI.colors.primary
        addSubview(baseFareIcon)
        
        _ = [baseFareIcon.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
             baseFareIcon.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 3.0),
             baseFareIcon.widthAnchor.constraint(equalToConstant: 12.0),
             baseFareIcon.heightAnchor.constraint(equalToConstant: 12.0)].map { $0.isActive = true }
        
        valueLabel = UILabel()
        valueLabel.accessibilityIdentifier = KHMetaDataViewID.valueLabel
        valueLabel.isAccessibilityElement = true
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.text = "Value"
        valueLabel.font = KarhooUI.fonts.bodyRegular()
        valueLabel.textColor = KarhooUI.colors.darkGrey
        valueLabel.textAlignment = .right
        valueLabel.numberOfLines = 0
        
        addSubview(valueLabel)
        _ = [valueLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
             valueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                  constant: -8.0)].map { $0.isActive = true }
        
        statusIcon = UIImageView(image: UIImage.uisdkImage("baseFare"))
        statusIcon.accessibilityIdentifier = KHMetaDataViewID.statusIcon
        statusIcon.translatesAutoresizingMaskIntoConstraints = false
        statusIcon.isHidden = true
        addSubview(statusIcon)
        
        _ = [statusIcon.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
             statusIcon.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: -5.0),
             statusIcon.widthAnchor.constraint(equalToConstant: 15.0),
             statusIcon.heightAnchor.constraint(equalToConstant: 15.0)].map { $0.isActive = true }
        
        actionButton = UIButton(type: .custom)
        actionButton.accessibilityIdentifier = KHMetaDataViewID.actionButton
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(actionButton)
        
        _ = [actionButton.topAnchor.constraint(equalTo: self.topAnchor),
             actionButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             actionButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             actionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)].map { $0.isActive = true }
    }
    
    // MARK: Public methods
    public func isBaseFareIconHidden(_ isHidden: Bool) {
        baseFareIcon.isHidden = isHidden
    }
    
    public func isActionButtonEnabled(_ value: Bool) {
        actionButton.isEnabled = value
    }
    
    public func setValue(_ value: String) {
        valueLabel.text = value
    }
    
    public func setValueColor(_ color: UIColor) {
        valueLabel.textColor = color
    }
    
    public func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    public func setStatusIcon(_ icon: UIImage?) {
        statusIcon.image = icon
        statusIcon.isHidden = false
    }
    
    public func setStatusIconTintColor(_ color: UIColor) {
        statusIcon.tintColor = color
    }
    
    public func isBottomLineHidden(_ value: Bool) {
        bottomLine.isHidden = value
    }
}
