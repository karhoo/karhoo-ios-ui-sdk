//
//  GradientView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

class GradientView: UIView {

    var gradient: CAGradientLayer
    
    init(gradient: CAGradientLayer) {
        self.gradient = gradient
        super.init(frame: .zero)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        accessibilityIdentifier = "gradientView"
        translatesAutoresizingMaskIntoConstraints = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.addSublayer(gradient)
        gradient.frame = bounds
    }
}
