//
//  KarhooStackButtonView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

public struct KHStackButtonID {
    public static let buttonOne = "button-one"
    public static let buttonTwo = "button-two"
}

final class KarhooStackButtonView: UIView, StackButtonView {

    private var buttonOne: UIButton!
    private var buttonOneWidthConstraint: NSLayoutConstraint!
    private var buttonTwo: UIButton!
    private var buttonTwoWidthConstraint: NSLayoutConstraint!
    private var topLine: LineView!
    private var containerStackView: UIStackView!

    var buttonOneAction: (() -> Void)?
    var buttonTwoAction: (() -> Void)?
    
    public init() {
        super.init(frame: .zero)
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let availableWidth = bounds.width - 1
        if !buttonOne.isHidden {
            if buttonOneWidthConstraint != nil {
                buttonOne.removeConstraint(buttonOneWidthConstraint)
            }
            buttonOneWidthConstraint = buttonOne.widthAnchor.constraint(
                greaterThanOrEqualToConstant: availableWidth / 2)
            buttonOneWidthConstraint.isActive = true
        }
        
        if !buttonTwo.isHidden {
            if buttonTwoWidthConstraint != nil {
                buttonTwo.removeConstraint(buttonTwoWidthConstraint)
            }
            buttonTwoWidthConstraint = buttonTwo.widthAnchor.constraint(
                greaterThanOrEqualToConstant: availableWidth / 2)
            buttonTwoWidthConstraint.isActive = true
        }
    }
    
    // MARK: View setup
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = "stack_button_view"
        
        topLine = LineView(color: .lightGray,
                           accessibilityIdentifier: "top_line")
        addSubview(topLine)
        _ = [topLine.topAnchor.constraint(equalTo: self.topAnchor),
             topLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             topLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             topLine.heightAnchor.constraint(equalToConstant: 1.0)].map { $0.isActive = true }
        
        containerStackView = UIStackView()
        containerStackView.accessibilityIdentifier = "container_stack"
        containerStackView.axis = .horizontal
        containerStackView.backgroundColor = .lightGray
        containerStackView.distribution = .fillEqually
        containerStackView.spacing = UIConstants.Spacing.xxxSmall
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerStackView)
        
        _ = [containerStackView.topAnchor.constraint(equalTo: topLine.bottomAnchor),
             containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
             containerStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50.0)
        ].map { $0.isActive = true}
        
        buttonOne = UIButton(type: .custom)
        buttonOne.translatesAutoresizingMaskIntoConstraints = false
        buttonOne.accessibilityLabel = buttonOneText
        buttonOne.accessibilityIdentifier = KHStackButtonID.buttonOne
        buttonOne.titleLabel?.lineBreakMode = .byWordWrapping
        buttonOne.titleLabel?.textAlignment = .center
        buttonOne.titleLabel?.font = KarhooUI.fonts.bodyRegular()
        buttonOne.addTarget(self, action: #selector(buttonOnePressed), for: .touchUpInside)
        buttonOne.setTitleColor(KarhooUI.colors.accent, for: .normal)
        buttonOne.backgroundColor = KarhooUI.colors.background2
        
        buttonTwo = UIButton(type: .custom)
        buttonTwo.translatesAutoresizingMaskIntoConstraints = false
        buttonTwo.accessibilityIdentifier = KHStackButtonID.buttonTwo
        buttonTwo.titleLabel?.lineBreakMode = .byWordWrapping
        buttonTwo.titleLabel?.textAlignment = .center
        buttonTwo.titleLabel?.font = KarhooUI.fonts.bodyRegular()
        buttonTwo.addTarget(self, action: #selector(buttonTwoPressed), for: .touchUpInside)
        buttonTwo.setTitleColor(KarhooUI.colors.accent, for: .normal)
        buttonTwo.backgroundColor = KarhooUI.colors.background2
        
        containerStackView.addArrangedSubview(buttonOne)
        containerStackView.addArrangedSubview(buttonTwo)
    }

    var buttonOneText: String? {
        didSet {
            buttonOne?.setTitle(buttonOneText, for: .normal)
            buttonOne?.accessibilityLabel = buttonOneText
        }
    }

    var buttonTwoText: String? {
        didSet {
            buttonTwo?.setTitle(buttonTwoText, for: .normal)
            buttonTwo?.accessibilityLabel = buttonTwoText
        }
    }

    func set(buttonText: String, action: @escaping () -> Void) {
        buttonOneText = buttonText
        buttonOneAction = action
        buttonTwo?.isHidden = true
        buttonTwoAction = nil
    }

    func set(firstButtonText: String, firstButtonAction: @escaping () -> Void,
             secondButtonText: String, secondButtonAction: @escaping () -> Void) {
        buttonOneText = firstButtonText
        buttonOneAction = firstButtonAction
        buttonTwoText = secondButtonText
        buttonTwoAction = secondButtonAction

        buttonTwo?.isHidden = false
    }

    @objc
    func buttonOnePressed() {
        buttonOneAction?()
    }

    @objc
    func buttonTwoPressed() {
        buttonTwoAction?()
    }
}
