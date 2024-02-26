//
//  UIImage+load.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 11/07/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import UIKit

extension UIImage {
    static let cache = NSCache<NSURL, UIImage>()
    private static let fetchImageQueue = DispatchQueue.global(qos: .utility)

    static func load(using url: URL, shouldBeCached: Bool = true, completion: @escaping (UIImage?) -> Void) {
        fetchImageQueue.async {
            guard let data = try? Data(contentsOf: url) else { return }
            let image = UIImage(data: data)
            if let fetchedImage = image,
                shouldBeCached,
                let nsUrl = NSURL(string: url.absoluteString) {
                cache.setObject(fetchedImage, forKey: nsUrl)
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
