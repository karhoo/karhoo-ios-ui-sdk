//
//  EmptyStateView.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

final class EmptyStateView: UIView {
    
    private var emptyStateMessageLabel: UILabel!
    private var emptyStateTitleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpView()
    }
    
    private func setUpView() {
        accessibilityIdentifier = "empty_state_view"
        
        translatesAutoresizingMaskIntoConstraints = false
        
        emptyStateTitleLabel = UILabel()
        emptyStateTitleLabel.accessibilityIdentifier = "empty_state_title"
        emptyStateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateTitleLabel.numberOfLines = 0
        emptyStateTitleLabel.textAlignment = .center
        emptyStateTitleLabel.font = KarhooUI.fonts.bodyBold()
        emptyStateTitleLabel.textColor = KarhooUI.colors.text
        addSubview(emptyStateTitleLabel)
        _ = [emptyStateTitleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
             emptyStateTitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)].map { $0.isActive = true }
        
        emptyStateMessageLabel = UILabel()
        emptyStateMessageLabel.accessibilityIdentifier = "empty_state_message"
        emptyStateMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateMessageLabel.numberOfLines = 0
        emptyStateMessageLabel.textAlignment = .center
        emptyStateMessageLabel.font = KarhooUI.fonts.bodyRegular()
        emptyStateMessageLabel.textColor = KarhooUI.colors.text
        addSubview(emptyStateMessageLabel)
        _ = [emptyStateMessageLabel.topAnchor.constraint(equalTo: emptyStateTitleLabel.bottomAnchor, constant: 32),
             emptyStateMessageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0),
             emptyStateMessageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                              constant: -8.0)].map { $0.isActive = true}
    }
}

// MARK: Public methods
extension EmptyStateView {
    public func setTitle(_ title: String) {
        emptyStateTitleLabel.text = title
    }
    
    public func setMessage(_ message: String) {
        emptyStateMessageLabel.text = message
    }
}
