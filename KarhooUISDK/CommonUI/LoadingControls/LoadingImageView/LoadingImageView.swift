//
//  LoadingImageView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

public final class LoadingImageView: UIView {

    private var cachingImageView: CachingImageView!
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

        cachingImageView = CachingImageView()
        cachingImageView.translatesAutoresizingMaskIntoConstraints = false
        cachingImageView.accessibilityIdentifier = "caching_image"
        cachingImageView.isAccessibilityElement = true
        
        addSubview(cachingImageView)
        _ = [cachingImageView.topAnchor.constraint(equalTo: self.topAnchor),
             cachingImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             cachingImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             cachingImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)].map { $0.isActive = true }
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.accessibilityIdentifier = "caching_activity_indicator"
        activityIndicator.style = .gray
        activityIndicator.hidesWhenStopped = true
        
        addSubview(activityIndicator)
        _ = [activityIndicator.centerXAnchor.constraint(equalTo: cachingImageView.centerXAnchor),
             activityIndicator.centerYAnchor.constraint(equalTo: cachingImageView.centerYAnchor)]
            .map { $0.isActive = true }
    }
    
    public func cancel() {
        activityIndicator?.stopAnimating()
        cachingImageView?.image = nil
    }

    public func load(imageURL: String, placeholderImageName: String?) {
        activityIndicator?.startAnimating()

        cachingImageView?.loadRemoteImage(urlString: imageURL,
                                          placeHolderImageName: placeholderImageName,
                                          completion: { [weak self] image in
            self?.image = image
                        
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator?.stopAnimating()
            }
        })
    }

    public func setStandardBorder() {
        layer.borderColor = KarhooUI.colors.darkGrey.withAlphaComponent(0.20).cgColor
        layer.borderWidth = 0.5
    }
}
