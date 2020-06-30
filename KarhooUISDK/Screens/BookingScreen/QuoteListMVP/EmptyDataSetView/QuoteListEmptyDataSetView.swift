//
//  QuoteListEmptyDataSetView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

public struct KHQuoteListEmptyDataSetViewID {
    public static let emptyMessageLabel = "empty_message_label"
}

final class QuoteListEmptyDataSetView: UIView, EmptyDataSetView {
    
    private var didSetupConstraints: Bool = false
    private var emptyMessageLabel: UILabel!
    
    init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        isAccessibilityElement = false
        accessibilityIdentifier = "quoteList_empty_view"
        
        emptyMessageLabel = UILabel()
        emptyMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyMessageLabel.isAccessibilityElement = true
        emptyMessageLabel.accessibilityIdentifier = KHQuoteListEmptyDataSetViewID.emptyMessageLabel
        emptyMessageLabel.textAlignment = .center
        emptyMessageLabel.textColor = KarhooUI.colors.medGrey
        addSubview(emptyMessageLabel)
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            _ = [emptyMessageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30.0),
                 emptyMessageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30.0),
                 emptyMessageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                 emptyMessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor)].map { $0.isActive = true }
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
    func show(emptyDataSetMessage: String) {
        isHidden = false
        emptyMessageLabel.text = emptyDataSetMessage
    }
    
    func hide() {
        isHidden = true
    }
}
