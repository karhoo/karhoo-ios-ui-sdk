//
//  BaseSelectionView.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

public struct KHBaseSelectionViewID {
    public static let thumbnailImage = "thumbnail_image"
    public static let foregroundThumbnailImage = "foreground_thumbnail_image"
    public static let titleLabel = "title_label"
}

public protocol BaseSelectionViewDelegate: class {
    func didSelectView(_ view: BaseSelectionView)
}

public class BaseSelectionView: UIView {
    
    private var foregroundThumbnailImage: UIImageView!
    private var thumbnailImage: UIImageView!
    private var titleLabel: UILabel!
    private let identifier: String
    private(set) var viewType: BaseSelectionViewType
    private var tapGesture: UITapGestureRecognizer!
    public weak var delegate: BaseSelectionViewDelegate?
    
    override public var tintColor: UIColor! {
        didSet {
            thumbnailImage.tintColor = tintColor
        }
    }

    @IBInspectable var typeAdapter: String {
        get { return self.viewType.rawValue }
        
        set {
            viewType = BaseSelectionViewType(rawValue: newValue) ?? .none
            updateViewType()
        }
     }
    
    init(type: BaseSelectionViewType, identifier: String = "") {
        self.viewType = type
        self.identifier = identifier
        super.init(frame: .zero)
        
        setUpView()
    }
        
    required init?(coder: NSCoder) {
        self.viewType = .none
        self.identifier = ""
        super.init(coder: coder)
        setUpView()
    }

    private func setUpView() {
        accessibilityIdentifier = identifier
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = KarhooUI.colors.white
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapGesture)
        
        thumbnailImage = UIImageView(frame: .zero)
        thumbnailImage.accessibilityIdentifier = KHBaseSelectionViewID.thumbnailImage
        thumbnailImage.contentMode = .scaleAspectFit
        thumbnailImage.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImage.tintColor = tintColor
        
        addSubview(thumbnailImage)
        
        _ = [thumbnailImage.widthAnchor.constraint(equalToConstant: 20.0),
             thumbnailImage.heightAnchor.constraint(equalToConstant: 27.0),
             thumbnailImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
             thumbnailImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.0),
             thumbnailImage.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                     constant: 10)].map { $0.isActive = true }
        
        if viewType == .mapDropOff || viewType == .mapPickUp {
            foregroundThumbnailImage = UIImageView(frame: .zero)
            foregroundThumbnailImage.accessibilityIdentifier = KHBaseSelectionViewID.foregroundThumbnailImage
            foregroundThumbnailImage.contentMode = .scaleAspectFit
            foregroundThumbnailImage.translatesAutoresizingMaskIntoConstraints = false
            
            thumbnailImage.addSubview(foregroundThumbnailImage)
            
            foregroundThumbnailImage.anchor(width: 10, height: 10)
            foregroundThumbnailImage.centerX(inView: thumbnailImage)
            foregroundThumbnailImage.centerY(inView: thumbnailImage, constant: -3)
        }
        
        titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.accessibilityIdentifier = KHBaseSelectionViewID.titleLabel
        titleLabel.font = KarhooUI.fonts.bodyRegular()
        titleLabel.textColor = KarhooUI.colors.darkGrey
        
        addSubview(titleLabel)
        _ = [titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
             titleLabel.leadingAnchor.constraint(equalTo: thumbnailImage.trailingAnchor, constant: 12.0),
             titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor,
                                                  constant: -10.0)].map { $0.isActive = true }
        
        updateViewType()
    }
    
    public func setViewType(_ type: BaseSelectionViewType) {
        viewType = type
        updateViewType()
    }
    
    private func updateViewType() {
        switch viewType {
        case .mapDropOff, .mapPickUp:
            tintColor = (viewType == .mapDropOff) ? KarhooUI.colors.secondary : KarhooUI.colors.primary
            thumbnailImage.image = UIImage.uisdkImage("pin_background_icon")
            foregroundThumbnailImage.image = UIImage.uisdkImage(viewType.rawValue)
        case .currentLocation:
            thumbnailImage.image = UIImage.uisdkImage(viewType.rawValue)
        case .none:
            break
        }
        titleLabel.text = viewType.titleText
    }
    
    @objc
    private func viewTapped() {
        delegate?.didSelectView(self)
    }
}
