//
//  KarhooNavigationBarView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

public enum NavigationBarItemIcon {
    case menuIcon
    case exitIcon
}

public struct KHNavigationBarID {
    public static let main = "navigationBar"
    public static let leftButton = "navigationBar_left_button"
    public static let rightButton = "navigationBar_right_button"
}

final class KarhooNavigationBarView: UIView, NavigationBarView {
    
    private var leftButton: UIButton!
    private var rightButton: UIButton!
    private var gradientView: GradientView!
    
    private weak var actions: NavigationBarActions?

    init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        accessibilityIdentifier = KHNavigationBarID.main
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        gradientView = GradientView(gradient: KarhooGradients().navigationBarGradient())
        addSubview(gradientView)
        
        _ = [gradientView.topAnchor.constraint(equalTo: topAnchor),
             gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
             gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
             gradientView.bottomAnchor.constraint(equalTo: bottomAnchor)].map { $0.isActive = true }
        
        leftButton = UIButton(type: .custom)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.accessibilityIdentifier = KHNavigationBarID.leftButton
        leftButton.tintColor = KarhooUI.colors.secondary
        leftButton.imageView?.contentMode = .scaleAspectFit
        leftButton.touchAreaEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
        leftButton.addTarget(self, action: #selector(leftButtonPressed), for: .touchUpInside)
        addSubview(leftButton)
        
        _ = [leftButton.topAnchor.constraint(equalTo: topAnchor, constant: 50),
             leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
             leftButton.widthAnchor.constraint(equalToConstant: 16),
             leftButton.heightAnchor.constraint(equalToConstant: 13),
             leftButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)].map { $0.isActive = true }
        
        rightButton = UIButton(type: .custom)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.accessibilityIdentifier = KHNavigationBarID.rightButton
        rightButton.setTitle(UITexts.Generic.rides, for: .normal)
        rightButton.setTitleColor(KarhooUI.colors.secondary, for: .normal)
        rightButton.titleLabel?.font = KarhooUI.fonts.headerRegular()
        rightButton.addTarget(self, action: #selector(rightButtonPressed), for: .touchUpInside)
        addSubview(rightButton)
        
        _ = [rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
             rightButton.heightAnchor.constraint(equalToConstant: 20),
             rightButton.centerYAnchor.constraint(equalTo: leftButton.centerYAnchor)].map { $0.isActive = true }
    }

    func set(actions: NavigationBarActions) {
        self.actions = actions
    }

    func set(leftIcon: NavigationBarItemIcon) {
        var leftImage = UIImage()
        switch leftIcon {
        case .menuIcon:
            leftImage = UIImage.uisdkImage("menu").withRenderingMode(.alwaysTemplate)
            
            
        case .exitIcon:
            leftImage = UIImage.uisdkImage("cross").withRenderingMode(.alwaysTemplate)
            leftButton.contentEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
        }
        
        leftButton.setImage(leftImage, for: .normal)
    }

    func set(rightItemHidden: Bool) {
        rightButton.isHidden = rightItemHidden
    }

    @objc
    private func rightButtonPressed() {
        actions?.rightButtonPressed()
    }

    @objc
    private func leftButtonPressed() {
        actions?.leftButtonPressed()
    }
}
