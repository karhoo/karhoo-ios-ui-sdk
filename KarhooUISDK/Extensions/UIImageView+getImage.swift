//
//  UIImageView+getImage.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 11/07/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import UIKit

extension UIImageView {
    func getImage(
        using url: URL?,
        placeholder: UIImage? = nil,
        completion: @escaping () -> Void = {}
    ) {
        if let placeholder = placeholder {
            image = placeholder
        }
        guard let url = url, let nsUrl = NSURL(string: url.absoluteString) else {
            completion()
            return
        }
        if let cachedImage = UIImage.cache.object(forKey: nsUrl) {
            image = cachedImage
        } else {
            UIImage.load(using: url) { [weak self] fetchedImage in
                self?.image = fetchedImage
            }
        }
        completion()
    }
}
