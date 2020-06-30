//
//  LineView.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

class LineView: UIView {
    
    let color: UIColor
    let width: CGFloat?
    
    public init(color: UIColor = .black,
                width: CGFloat? = nil,
                accessibilityIdentifier: String) {
        self.color = color
        self.width = width
        
        super.init(frame: .zero)
        self.accessibilityIdentifier = accessibilityIdentifier
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        backgroundColor = color
        translatesAutoresizingMaskIntoConstraints = false
        if let width = self.width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
}
