//
//  BordedLabel.swift
//  TripVIew
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

public struct KHBordedLabelViewID {
    public static let label = "bordedLabel"
}

final class BordedLabel: UIView {
    
    private var label: UILabel!
    private var title: String
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        self.setUpView()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        addOuterShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        accessibilityIdentifier = "borded_container"
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
        
        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHBordedLabelViewID.label
        label.isAccessibilityElement = true
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = KarhooUI.fonts.bodyBold()
        label.text = title
        label.textColor = .black
        
        addSubview(label)
        _ = [label.topAnchor.constraint(equalTo: self.topAnchor, constant: 3.0),
             label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0),
             label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0),
             label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3.0)].map { $0.isActive = true }
    }
    
    public func setTitle(_ title: String) {
        label.text = title
    }
}
