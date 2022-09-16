//
//  DropDownButton.swift
//  TripVIew
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

public protocol DropDownButtonDelegate: class {
    func buttonTapped(_ value: Bool)
}

public struct KHDropDownButtonID {
    public static let buttonTitle = "title"
    public static let dropDownImage = "drop_down_image"
}

final class DropDownButton: UIView {
    
    private var buttonTitle: UILabel!
    private var dropDownImage: UIImageView!
    private var tapped: Bool = false
    
    public weak var delegate: DropDownButtonDelegate?
    
    init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        accessibilityIdentifier = "drop_down_button"
        translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        self.addGestureRecognizer(tapGesture)
        
        buttonTitle = UILabel()
        buttonTitle.accessibilityIdentifier = KHDropDownButtonID.buttonTitle
        buttonTitle.translatesAutoresizingMaskIntoConstraints = false
        buttonTitle.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        buttonTitle.textAlignment = .center
        buttonTitle.textColor = .darkGray
        buttonTitle.text = UITexts.Trip.tripRideOptions
        addSubview(buttonTitle)
        
        dropDownImage = UIImageView(image: UIImage.uisdkImage("kh_drop_down_arrow"))
        dropDownImage.tintColor = .darkGray
        dropDownImage.translatesAutoresizingMaskIntoConstraints = false
        dropDownImage.accessibilityIdentifier = KHDropDownButtonID.dropDownImage
        dropDownImage.isAccessibilityElement = true
        dropDownImage.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi)
        let imageSize: CGFloat = 10
        addSubview(dropDownImage)
        
        _ = [buttonTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 30.0),
             buttonTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30.0),
             buttonTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5.0),
             buttonTitle.trailingAnchor.constraint(equalTo: dropDownImage.leadingAnchor,
                                                   constant: -5.0)].map { $0.isActive = true }
        
        _ = [dropDownImage.centerYAnchor.constraint(equalTo: buttonTitle.centerYAnchor),
             dropDownImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5.0),
             dropDownImage.widthAnchor.constraint(equalToConstant: imageSize),
             dropDownImage.heightAnchor.constraint(equalToConstant: imageSize)].map { $0.isActive = true }
    }
    
    public func getButtonState() -> Bool {
        return tapped
    }
    
    @objc
    private func buttonTapped() {
        
        tapped = !tapped
        
        var animation: CGAffineTransform
        if tapped {
            animation = .identity
        } else {
            animation = CGAffineTransform.init(rotationAngle: CGFloat.pi)
        }
        
        UIView.animate(withDuration: 0.2) {
            self.dropDownImage.transform = animation
        }
        
        delegate?.buttonTapped(tapped)
    }
}
