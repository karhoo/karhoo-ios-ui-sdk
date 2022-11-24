//
//  LoadingImageView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import SwiftUI

public final class LoadingImageView: UIView {

    private var imageView: UIImageView!
    private var activityIndicator: UIActivityIndicatorView!
    private(set) var image: UIImage!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpView()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
    }
    
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false

        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.accessibilityIdentifier = "caching_image"
        imageView.isAccessibilityElement = true
        
        addSubview(imageView)
        _ = [imageView.topAnchor.constraint(equalTo: self.topAnchor),
             imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)].map { $0.isActive = true }
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.accessibilityIdentifier = "caching_activity_indicator"
        activityIndicator.style = .gray
        activityIndicator.hidesWhenStopped = true
        
        addSubview(activityIndicator)
        _ = [activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
             activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)]
            .map { $0.isActive = true }
    }
    
    public func cancel() {
        activityIndicator?.stopAnimating()
        imageView?.image = nil
    }

    public func load(imageURL: String, placeholderImageName: String?) {
        activityIndicator?.startAnimating()
        
        imageView?.getImage(
            using: URL(string: imageURL),
            placeholder: UIImage.uisdkImage(placeholderImageName ?? ""),
            completion: { [weak self] image in
                self?.image = image
                self?.activityIndicator?.stopAnimating()
            }
        )
    }

    public func setStandardBorder() {
        layer.borderColor = KarhooUI.colors.darkGrey.withAlphaComponent(0.20).cgColor
        layer.borderWidth = 0.5
    }
}
