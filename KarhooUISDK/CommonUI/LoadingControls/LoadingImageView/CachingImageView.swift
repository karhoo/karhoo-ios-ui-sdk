//
//  CachingImageView.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import UIKit

final class CachingImageView: UIImageView {

    private let imageCache = NSCache<AnyObject, AnyObject>()
    private var imageUrlString: String?

    func loadRemoteImage(urlString: String,
                         placeHolderImageName: String?,
                         completion: @escaping ((UIImage?) -> Void)) {

        self.image = UIImage.uisdkImage(placeHolderImageName ?? "")
        self.imageUrlString = urlString

        guard let imageUrl = URL(string: urlString) else {
            completion(nil)
            return
        }

        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: imageUrl, completionHandler: { (data, _, _) in

            guard let imageData = data else {
                completion(nil)
                return
            }

            DispatchQueue.main.async { [weak self] in
                guard let imageToCache = UIImage(data: imageData) else {
                    completion(nil)
                    return
                }

                if self?.imageUrlString == urlString {
                    self?.image = imageToCache
                }

                self?.imageCache.setObject(imageToCache,
                                           forKey: urlString as AnyObject)

                completion(imageToCache)
            }
        }).resume()
    }
}
